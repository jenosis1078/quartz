---
type: note
area: DX
source: "https://claude.com/product/cowork"
created: 2026-04-04
tags: [topic/dx, topic/llm, type/note, source/anthropic]
status: done
---

# Claude Cowork

> Claude Code의 에이전틱 아키텍처를 데스크톱 지식 업무로 확장한 AI 어시스턴트. 
> 터미널 없이 Claude Desktop에서 멀티스텝 작업을 자율 수행.

## 배경

2025년 Claude Code가 개발자 워크플로우를 혁신한 데 이어, 2026년 1월 12일 **코딩 이외의 지식 업무**를 대상으로 Cowork 리서치 프리뷰 출시.

> "In 2025 Claude transformed how developers work, and in 2026 it will do the same for knowledge work." — Anthropic

---

## 아키텍처

![[claude-cowork-architecture.svg|697]]

---

## 핵심 특징

### 에이전틱 실행
일반 채팅과 달리 Claude가 **직접** 파일을 읽고·수정·생성:
- 폴더 내 파일 정리 (유형·날짜별 분류)
- 영수증 → 경비 보고서 자동 생성
- 회의록에서 테마 추출 → 요약 보고서
- 웹 검색 결과 → 리서치 리포트 병합

### 로컬 파일 접근
사용자가 지정한 폴더에 대해 읽기·수정·생성 권한을 가짐.
**VM 환경**에서 실행되어 메인 OS와 격리 → 보안 유지.

### Scheduled Tasks (예약 작업)
일반 채팅에서는 불가능한 **자동 반복 실행** — Cowork만의 차별점.
정해진 스케줄에 따라 데이터 수집·보고서 생성 등을 자동화.

---

## 플러그인 시스템

Cowork의 확장은 **플러그인** 단위로 이루어진다.

### 플러그인 구성
| 요소 | 설명 |
|------|------|
| **Skills** | 특정 동작·출력 포맷 정의 |
| **Commands** | `/명령어`로 트리거하는 구조화된 워크플로우 |
| **Connectors** | 외부 데이터 소스·도구 연결 (MCP 기반) |

### 부서별 프리빌트 플러그인
HR · 디자인 · 엔지니어링 · 운영 · 재무 분석 · 법무 · 영업 · 마케팅 등 10개 이상의 도메인별 템플릿 제공.

### Enterprise 플러그인 마켓플레이스
조직 관리자가 **프라이빗 마켓플레이스**를 구축하여 사내 플러그인을 배포·관리할 수 있다.

---

## MCP 커넥터 (2026년 2월 기준)

| 카테고리 | 커넥터 |
|---------|--------|
| **Google** | Calendar, Drive, Gmail |
| **영업** | Apollo, Clay, Outreach, Similarweb |
| **법무/금융** | DocuSign, LegalZoom, FactSet, MSCI |
| **콘텐츠** | WordPress |
| **법률 AI** | Harvey |

크로스앱 워크플로우: Excel ↔ PowerPoint 간 데이터 연동도 지원.

---

## Claude Code vs Cowork

| 항목 | Claude Code | Cowork |
|------|------------|--------|
| 대상 | 개발자 | 지식 근로자 전반 |
| 인터페이스 | 터미널 / IDE | Claude Desktop |
| 핵심 작업 | 코드 작성·디버깅·테스트 | 문서·데이터·리서치 처리 |
| 파일 접근 | 프로젝트 디렉토리 | 사용자 지정 폴더 |
| 확장 | Skills · Hooks · MCP | Plugins · Connectors |
| 실행 환경 | 로컬 셸 | VM 샌드박스 |

---

## 플랫폼 지원

| 플랫폼 | 출시일 | 상태 |
|--------|--------|------|
| macOS | 2026-01-12 | 정식 |
| Windows | 2026-02-10 | 정식 (macOS 기능 동등) |

---

## 명령어 레퍼런스

Cowork에서 사용하는 명령어는 **슬래시 명령어**, **빌트인 스킬**, **플러그인 명령어**로 분류된다.

### 슬래시 명령어 (Cowork 세션 내)
| 명령어 | 설명 |
|--------|------|
| `/help` | 사용 가능한 전체 명령어·스킬 목록 표시 |
| `/schedule` | 예약 작업 생성·관리 (Cowork 핵심 기능) |
| `/compact [지시]` | 대화 기록 요약 압축. 보존할 정보 지정 가능 |
| `/clear` | 대화 기록 전체 삭제 |
| `/model <모델>` | 모델 전환 |
| `/cost` | 토큰 사용량·비용 표시 |
| `/export` | 대화를 파일/클립보드로 내보내기 |
| `/mcp` | MCP 커넥터 연결 상태·도구 확인 |
| `/plugins` | 설치된 플러그인 목록·관리 |
| `/memory` | 프로젝트 메모리 파일 열기·편집 |

### 빌트인 스킬 (파일 생성)
| 스킬 | 설명 |
|------|------|
| `/pdf` | PDF 파일 생성 |
| `/docx` | Word 문서 생성 |
| `/pptx` | PowerPoint 프레젠테이션 생성 |
| `/xlsx` | Excel 스프레드시트 생성 |
| `/canvas-design` | 캔버스 기반 디자인 생성 |
| `/algorithmic-art` | 알고리즘 아트 생성 |
| `/skill-creator` | 새로운 커스텀 스킬 생성 도우미 |

### 예약 작업 명령어
| 명령어 | 설명 |
|--------|------|
| `/schedule create` | 새 예약 작업 생성 |
| `/schedule list` | 예약 작업 목록 조회 |
| `/schedule run <이름>` | 예약 작업 즉시 실행 |
| `/schedule delete <이름>` | 예약 작업 삭제 |

> 예약 작업은 일반 Cowork 작업과 동일한 도구·스킬·플러그인에 접근 가능.

### 폴더·작업 관리
| 동작 | 설명 |
|------|------|
| 폴더 생성 | Cowork 탭에서 프로젝트별 전용 폴더 생성 |
| 작업 할당 | 시스템 트레이/메뉴바에서 어디서든 Claude에 작업 할당 |
| 파일 접근 설정 | Settings → Cowork에서 접근 허용 폴더 지정 |

### 공식 플러그인별 명령어
각 플러그인은 도메인 특화 슬래시 명령어를 번들로 제공한다:

| 플러그인 | 주요 명령어 예시 | 설명 |
|---------|----------------|------|
| **Sales** | `/prospect`, `/pipeline` | 리드 분석, 파이프라인 리포트 |
| **Legal** | `/contract-review`, `/compliance` | 계약서 검토, 규정 준수 확인 |
| **Finance** | `/expense-report`, `/forecast` | 경비 보고서, 재무 예측 |
| **Marketing** | `/campaign`, `/content-brief` | 캠페인 기획, 콘텐츠 브리프 |
| **Support** | `/ticket-summary`, `/escalation` | 티켓 요약, 에스컬레이션 판단 |
| **Product** | `/prd`, `/user-research` | PRD 작성, 사용자 리서치 정리 |
| **Data Analysis** | `/analyze`, `/visualize` | 데이터 분석, 시각화 |
| **Enterprise Search** | `/search`, `/summarize` | 사내 문서 검색, 요약 |
| **Research** | `/literature-review`, `/synthesis` | 문헌 리뷰, 종합 보고서 |
| **HR** | `/onboarding`, `/policy` | 온보딩 문서, 정책 문서 생성 |
| **Design** | `/design-brief`, `/style-guide` | 디자인 브리프, 스타일 가이드 |

> 플러그인은 `claude.com/plugins` 또는 Enterprise 프라이빗 마켓플레이스에서 설치.

### MCP 커넥터 명령어
MCP 커넥터가 연결되면 `/mcp__<커넥터>__<동작>` 형식으로 호출 가능:

| 커넥터 | 명령어 예시 | 설명 |
|--------|-----------|------|
| Gmail | `/mcp__gmail__search` | 이메일 검색 |
| Google Drive | `/mcp__gdrive__list` | 드라이브 파일 목록 |
| Google Calendar | `/mcp__gcal__events` | 일정 조회 |
| Slack | `/mcp__slack__messages` | 메시지 조회 |
| GitHub | `/mcp__github__issues` | 이슈 목록 |

---

## 사용 요건
- **Claude Pro** 이상 구독 필요
- Claude Desktop 앱 설치
- Cowork 기능 활성화 (Settings → Cowork)

---

## 관련 노트
- [[00-OverView|Claude Overview]]
- [[01-Models|Claude Models]]
- [[02-Claude Code|Claude Code]]
- [[03-Claude Skills|Claude Skills]]

---

> 이 노트는 Claude Code로 작성되었습니다. 
> 무단 배포를 금지합니다.
