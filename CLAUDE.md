# bio — 한수진 링크인바이오 작업 규칙

한 페이지 정적 사이트. 빌드 없음 — `index.html` 하나가 정본.

## 수정 시 반드시
- 내용을 바꾸면 **신선도 날짜 2곳**을 `YY.MM.DD`로 갱신: ① 게이트웨이 updated-chip ② 푸터 `<time id="pageUpdated">` (datetime 속성은 `YYYY-MM-DD`).
- 경력·직함·수치는 **확인된 사실만** (이력서·공식 문서 기준). 추측 금지.
- 🚨 이 레포는 공개(전환 후)다 — **전화번호·생년월일·주소·계좌·신분증·비공개 프로젝트명은 절대 커밋 금지.** 공개 범위 = 이름·직함·공개 경력·공개 SNS·연락용 이메일(h_sj0525@naver.com)까지.

## 자주 하는 일
- 팔로워 숫자 갱신: `bash scripts/refresh-followers.sh --deploy` (수집→커밋→푸시 원샷. 주 1회는 GitHub Actions가 자동으로 함)
- 배포 = `git push` (GitHub Pages가 1~2분 내 자동 반영)
- 새 SNS 계정 추가: `assets/followers.json` 항목 + 스크립트 fetch 함수 + `index.html` 소셜 아이콘, 세 곳 모두.
- SNS 합계 블록은 총합 1,000 미만이면 자동 숨김 — 억지로 켜지 말 것.

## 연결
- 수콘AI 포트폴리오(`~/ai-portfolio/v2`, hotsujin.github.io/suconn-ai)와 직함·대표 수치를 공유 — 한쪽을 바꾸면 다른 쪽도 확인.
- 템플릿 출처: [johnfkoo951/cmds-bio](https://github.com/johnfkoo951/cmds-bio) — 푸터 크레딧 유지.
