# bio — 한수진 링크인바이오

한수진 (Sujin Han) 개인 **링크인바이오** 페이지.
litt.ly / Linktree 를 대체하는 self-hosted 한 페이지짜리 정적 사이트.

- **Live** — 아직 비공개 (공개 전환 시 https://hotsujin.github.io/bio/ 에 뜸)
- **스택** — 순수 `index.html` 1개 (인라인 CSS/JS, 빌드 없음) + `assets/` 이미지·데이터
- **베이스** — [johnfkoo951/cmds-bio](https://github.com/johnfkoo951/cmds-bio) (구요한)를 포크 가이드에 따라 가져와 전면 교체

## 내용 고치기 (비개발자용)

Claude Code에서 이 폴더(`~/bio`)를 열고 말로 시키면 됩니다.
예: "링크 하나 추가해줘", "직함 바꿔줘", "팔로워 숫자 갱신해줘".

직접 고칠 때:

```bash
# 1) 편집 — index.html 만 고치면 됨 (링크/소셜/바이오/색상 전부 이 파일 안에)
#    콘텐츠 변경 시 신선도 날짜 2곳 갱신: 게이트웨이 칩(26.MM.DD) + 푸터 <time id="pageUpdated">

# 2) (선택) SNS 팔로워 수 재수집 — assets/followers.json 갱신
bash scripts/refresh-followers.sh

# 3) 배포 = git push (1~2분 뒤 사이트 반영)
git add -A && git commit -m "내용 갱신" && git push
```

## SNS 팔로워 자동 집계

- `assets/followers.json` 을 페이지가 읽어 소셜 아이콘 아래 숫자와 합계를 표시.
- **합계 블록은 총합 1,000 미만이면 자동 숨김** — 숫자가 자라면 저절로 나타난다.
- **매주 월요일 09:00(KST)** GitHub Actions 가 `scripts/refresh-followers.sh` 를 돌려 자동 갱신·커밋 (`.github/workflows/refresh-followers.yml`).
- 새 계정(YouTube·Threads 등)이 생기면: `followers.json` 에 항목 추가 + 스크립트에 수집 함수 추가 + `index.html` 소셜 아이콘 추가.

## 폴더 구조

```
bio/
├── index.html          # 페이지 본체 (프로필·소셜·링크 전부)
├── assets/
│   ├── profile-sujin.jpg     # 대표사진 (정사각)
│   ├── og-bio.png            # 1200×630 공유 카드 이미지
│   ├── favicon.png           # 파비콘 ("수" 모노그램)
│   ├── apple-touch-icon.png  # iOS 홈화면 아이콘
│   └── followers.json        # SNS 팔로워 수 + asOf (페이지가 fetch, 스크립트로 갱신)
├── scripts/
│   └── refresh-followers.sh  # SNS 팔로워 재수집 → followers.json 갱신
└── .github/workflows/
    └── refresh-followers.yml # 주 1회 자동 수집·커밋
```

## ⚠️ 개인정보 주의

이 레포는 **public** 입니다. 전화번호·생년월일·주소·계좌·신분증 등 민감정보는 절대 커밋하지 않습니다.
공개 범위 = 이름·직함·공개 경력·공개 SNS·연락용 이메일까지만.

## 따라 만들기 (Fork 가이드)

원본 [cmds-bio](https://github.com/johnfkoo951/cmds-bio) 의 가이드와 동일합니다. 포크 후:

1. `index.html` 의 프로필·링크·색상 토큰(`:root` CSS 변수) 교체, `assets/` 이미지 교체
2. `scripts/refresh-followers.sh` 의 SNS 핸들을 본인 계정으로 수정
3. GitHub Pages(또는 아무 정적 호스팅)에 배포 — 빌드 없음, 파일 그대로
