#!/bin/bash

# 한수진 링크인바이오 — SNS 팔로워/구독자 수 갱신 스크립트
#
# 사용법:
#   bash scripts/refresh-followers.sh            # 재수집만 (assets/followers.json 갱신)
#   bash scripts/refresh-followers.sh --deploy   # 갱신 후 git commit+push까지 (1~2분 뒤 사이트 반영)
#
# 수집 경로 (모두 서버사이드 — 브라우저에서는 CORS/로그인월로 불가):
#   Instagram  : web_profile_info 내부 API + x-ig-app-id 헤더 (정확값, 변경에 취약)
#   GitHub     : 공식 REST API (정확값)
#
# 실패한 플랫폼은 기존 값을 유지하므로 부분 실패에 안전.
# 새 계정(YouTube·Threads 등)이 생기면: followers.json에 항목 추가 + 아래에 fetch 함수 추가.

set -uo pipefail
cd "$(dirname "$0")/.."

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126 Safari/537.36"
JSON="assets/followers.json"

IG_HANDLE="wellme.seoul"
GH_USER="hotsujin"

DO_DEPLOY=false
while [ $# -gt 0 ]; do
    case "$1" in
        --deploy) DO_DEPLOY=true; shift ;;
        *) echo "알 수 없는 옵션: $1"; exit 1 ;;
    esac
done

fetch_instagram() {
    curl -s --max-time 20 -A "$UA" \
        -H "x-ig-app-id: 936619743392459" \
        "https://www.instagram.com/api/v1/users/web_profile_info/?username=${IG_HANDLE}" \
        | python3 -c "import json,sys; print(json.load(sys.stdin)['data']['user']['edge_followed_by']['count'])" 2>/dev/null
}

fetch_github() {
    curl -s --max-time 20 "https://api.github.com/users/${GH_USER}" \
        | python3 -c "import json,sys; print(json.load(sys.stdin)['followers'])" 2>/dev/null
}

IG=$(fetch_instagram) || IG=""
GH=$(fetch_github)    || GH=""

python3 - "$JSON" "$IG" "$GH" <<'PY'
import json, re, sys
from datetime import date

path, ig, gh = sys.argv[1:4]
data = json.load(open(path))

def parse_display(raw):
    """'12.6K' → (12600, '12.6K', approx=True) / '427' → (427, '427', False) / 0 → display 빈칸"""
    raw = raw.strip().replace(",", "")
    if not raw:
        return None
    m = re.match(r"^([\d.]+)([KM]?)$", raw, re.I)
    if not m:
        return None
    num, suffix = float(m.group(1)), m.group(2).upper()
    if suffix == "K":
        return int(num * 1_000), raw if raw.upper().endswith("K") else f"{raw}K", True
    if suffix == "M":
        return int(num * 1_000_000), raw, True
    n = int(num)
    display = "" if n == 0 else (f"{n:,}" if n >= 1000 else str(n))
    return n, display, False

updates = {"instagram": ig, "github": gh}
changed = []
for p in data["platforms"]:
    raw = updates.get(p["id"], "")
    parsed = parse_display(raw) if raw else None
    if parsed:
        old = p["count"]
        p["count"], p["display"], p["approx"] = parsed
        if old != p["count"]:
            changed.append(f"{p['label']}: {old} → {p['count']}")

if ig or gh:
    data["asOf"] = date.today().isoformat()
else:
    print("⚠️ 모든 플랫폼 수집 실패 — asOf 미갱신 (기존 날짜 유지)")
json.dump(data, open(path, "w"), ensure_ascii=False, indent=2)
open(path, "a").write("\n")

total = sum(p["count"] for p in data["platforms"] if isinstance(p["count"], int))
print(f"✅ {path} 갱신 완료 (asOf {data['asOf']})")
print(f"   합계: {total:,}  (1,000 미만이면 페이지의 합계 블록은 자동 숨김)")
print("   변경:", "; ".join(changed) if changed else "없음")
PY

if [ "$DO_DEPLOY" = true ]; then
    echo ""
    echo "🚀 git push 중... (Pages 활성화 상태면 1~2분 내 사이트 반영)"
    git add assets/followers.json
    git diff --cached --quiet || git commit -m "chore: SNS 팔로워 수 갱신"
    git push
else
    echo ""
    echo "다음 단계: git add/commit/push 하면 1~2분 뒤 사이트에 반영 (또는 --deploy 플래그)"
fi
