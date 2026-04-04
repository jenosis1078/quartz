---
type: note
area: DX
source: "https://code.claude.com/docs/en/skills"
created: 2026-04-04
tags: [topic/dx, topic/llm, type/note, source/anthropic]
status: done
---

# Claude Skills

> Claude Code의 프롬프트 기반 확장 시스템.
> SKILL.md 파일로 Claude의 동작을 커스터마이즈하고, `/skill-name`으로 호출.

## 아키텍처

![[claude-skills-architecture.svg|697]]

---

## 개념

### Slash Commands vs Skills
- **Slash Commands**: `/clear`, `/compact` 등 하드코딩된 고정 동작
- **Skills**: 프롬프트 기반 — YAML frontmatter + 마크다운 지시문으로 구성된 확장 가능한 동작

v2.1.3에서 기존 커스텀 슬래시 명령(`.claude/commands/`)이 Skills 시스템으로 **통합**됨.
기존 `.claude/commands/*.md` 파일은 그대로 동작하면서 Skills로도 인식된다.

---

## SKILL.md 구조

```markdown
---
name: api-route
description: "Next.js API route 생성 with Zod validation"
trigger: /api-route
---

# API Route Generator

## Trigger
/api-route <경로> <설명>

## Instructions
1. `app/api/<경로>/route.ts` 파일 생성
2. Zod 스키마로 입력 검증
3. 에러 핸들링 포함
4. 대응하는 테스트 파일 생성
```

두 부분으로 구성:
1. **YAML frontmatter**: 이름, 설명, 트리거 조건 — Claude가 언제 이 스킬을 사용할지 판단
2. **마크다운 본문**: Claude가 따를 구체적 지시사항

---

## 스킬 배치 경로

| 경로 | 범위 |
|------|------|
| `~/.claude/skills/` | 글로벌 (모든 프로젝트) |
| `.claude/skills/` | 프로젝트 로컬 |

디렉토리 내 `SKILL.md` 파일을 Claude Code가 자동 인식.

---

## 명령어 레퍼런스

Skills 시스템에서 사용하는 명령어는 크게 세 가지로 분류된다:
**빌트인 슬래시 명령어** (Skills와 관련된), **빌트인 스킬**, **스킬 관리 명령어**.

### 스킬 관리 명령어
| 명령어 / 경로 | 설명 |
|--------------|------|
| `/help` | 사용 가능한 모든 명령어·스킬 목록 표시 |
| `/init` | CLAUDE.md 생성 (스킬이 참조하는 프로젝트 설정) |
| `/memory` | CLAUDE.md 열기·편집 |
| `/agents` | 서브에이전트 목록·생성·관리 (스킬과 연동) |
| `~/.claude/skills/` | 글로벌 스킬 배치 경로 |
| `.claude/skills/` | 프로젝트 로컬 스킬 배치 경로 |
| `~/.claude/commands/` | 레거시 커스텀 명령어 (스킬로 자동 인식) |
| `.claude/commands/` | 레거시 프로젝트 커스텀 명령어 |

### 빌트인 스킬 (Skills 시스템으로 제공)

| 스킬 | 설명 |
|------|------|
| `/simplify` | 변경된 코드의 재사용성·품질·효율성 검토 후 개선 |
| `/commit` | 변경 사항 분석 → 커밋 메시지 작성 → 커밋 |
| `/review` | 코드 리뷰 (3-에이전트 파이프라인: 아키텍처·중복·성능 검사) |
| `/batch` | 대규모 변경을 여러 워크트리에서 병렬 실행 → 자동 PR 생성 |
| `/loop <간격> <명령>` | 일정 주기로 프롬프트/명령 반복 실행 (기본 10분) |
| `/debug` | 에러 분석·디버깅 지원 |
| `/claude-api` | Anthropic API / SDK 코드 작성 지원 |
| `/schedule` | 원격 예약 에이전트 생성·관리 (크론 스케줄) |
| `/plan` | Plan 모드 전환 — 모든 변경을 사전 승인 후 실행 |

### Skills와 함께 쓰이는 빌트인 슬래시 명령어
| 명령어 | 설명 |
|--------|------|
| `/compact [지시]` | 컨텍스트 압축 (스킬 실행 중 토큰 확보) |
| `/model <모델>` | 모델 전환 (스킬별 최적 모델 선택) |
| `/cost` | 토큰 사용량 확인 (스킬 실행 비용 추적) |
| `/diff` | 스킬이 변경한 파일 diff 확인 |
| `/hooks` | Hook 관리 (스킬 실행 전후 트리거 설정) |
| `/mcp` | MCP 서버 상태 확인 (스킬이 사용하는 외부 도구) |
| `/export` | 스킬 실행 결과를 파일/클립보드로 내보내기 |

### 커스텀 스킬 호출
| 형식 | 설명 |
|------|------|
| `/<스킬명>` | SKILL.md의 trigger로 정의한 이름으로 호출 |
| `/<스킬명> <인자>` | 인자를 전달하여 호출 (프롬프트 내 `$ARGUMENTS` 치환) |
| `/mcp__<서버>__<프롬프트>` | MCP 서버가 제공하는 프롬프트를 슬래시 명령으로 호출 |

---

## 커스텀 스킬 작성 가이드

### 좋은 스킬의 조건
- **구체적이고 의견이 있는**: "코드 작성 도와줘" ✗ → "Zod 검증이 포함된 Next.js API route 생성" ✓
- **간결한**: SKILL.md가 500줄 이상이면 Claude가 후반부를 경시
- **단일 책임**: 하나의 스킬은 하나의 잘 정의된 작업을 수행

### 예시: 컴포넌트 생성 스킬

```markdown
---
name: react-component
description: "프로젝트 컨벤션에 맞는 React 컴포넌트 생성"
trigger: /component
---

# React Component Generator

## Instructions
1. `src/components/<Name>/` 디렉토리 생성
2. `index.tsx` — 컴포넌트 본체 (Props 타입 export)
3. `<Name>.test.tsx` — 기본 렌더 테스트
4. `<Name>.stories.tsx` — Storybook 스토리

## Rules
- CSS Modules 사용 (`<Name>.module.css`)
- forwardRef 적용
- 접근성: aria 속성 포함
```

---

## Slash Commands에서 Skills로 마이그레이션

```
# 기존 (v2.1.3 이전)
.claude/commands/deploy.md

# 새 방식
.claude/skills/deploy/SKILL.md

# 둘 다 /deploy 로 호출 가능 — 기존 파일도 계속 동작
```

---

## 커뮤니티 스킬 생태계

[awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)에서 커뮤니티가 만든 스킬·후크·플러그인 모음을 확인할 수 있다.

---

## 관련 노트
- [[00-OverView|Claude Overview]]
- [[01-Models|Claude Models]]
- [[02-Claude Code|Claude Code]]
- [[04-Claude Cowork|Claude Cowork]]

---

> 이 노트는 Claude Code로 작성되었습니다.
> 무단 배포를 금지합니다.
