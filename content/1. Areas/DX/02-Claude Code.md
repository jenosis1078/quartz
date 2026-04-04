---
type: note
area: DX
source: "https://code.claude.com"
created: 2026-04-04
tags: [topic/dx, topic/llm, type/note, source/anthropic]
status: done
---

# Claude Code

> Anthropic의 에이전틱 코딩 도구. 터미널·IDE에서 코드베이스 전체를 이해하고, 파일 수정·테스트·커밋까지 자율 수행.

## 아키텍처

![[claude-code-architecture.svg|697]]

---

## 핵심 특징

### 에이전틱 코딩
단순 자동완성이 아닌 **멀티스텝 에이전트** 방식:
1. 코드베이스 전체 읽기 → 파일 간 관계 파악
2. 작업 계획 수립
3. 다수 파일 동시 수정
4. 테스트 실행 → 실패 시 자동 수정 반복
5. 커밋·PR 생성

### Extended Thinking
기본 활성화 — 복잡한 문제를 답변 전 내부 추론 과정을 거쳐 해결.

### 대규모 컨텍스트
Opus 4.6 기준 **100만 토큰** 컨텍스트 → 대규모 모노레포도 한 번에 파악.

---

## 실행 환경

| 환경 | 설명 |
|------|------|
| **터미널 CLI** | `claude` 명령어로 직접 실행 |
| **VS Code** | 네이티브 확장 (Cursor, Windsurf 포크 포함) |
| **JetBrains** | IntelliJ 계열 IDE 플러그인 |
| **Web** | claude.ai/code 에서 브라우저 실행 |
| **Desktop App** | Mac / Windows 독립 앱 |

---

## 설치 및 실행
```bash
# npm 글로벌 설치
npm install -g @anthropic-ai/claude-code

# 실행
claude
```

---

## 주요 기능

### CLAUDE.md
프로젝트 루트에 `CLAUDE.md` 파일을 두면 Claude가 대화 시작 시 자동 로드.
코딩 컨벤션, 아키텍처 규칙, 빌드 명령어 등 **프로젝트별 지침**을 설정한다.

```markdown
# CLAUDE.md 예시
- TypeScript strict mode 사용
- 테스트는 vitest로 실행: `npm run test`
- 커밋 메시지는 conventional commits 규칙
```

계층 구조: `~/.claude/CLAUDE.md` (글로벌) → 프로젝트 루트 → 하위 디렉토리 순으로 병합.

### Hooks
도구 실행 전후에 셸 커맨드를 자동 트리거하는 라이프사이클 이벤트 시스템.
`settings.json`에서 설정하며, 21개 이벤트를 지원한다.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "command": "echo 'File write detected'"
      }
    ]
  }
}
```

주요 이벤트: `PreToolUse`, `PostToolUse`, `PermissionDenied`, `Stop` 등.

### Subagents (서브에이전트)
복잡한 작업을 여러 에이전트에 분산 처리. 마크다운 + YAML frontmatter로 정의.

```markdown
---
description: "테스트 실행 에이전트"
tools: ["Bash", "Read", "Grep"]
model: sonnet
---
프로젝트의 테스트를 실행하고 결과를 요약합니다.
```

`/agents` 명령 또는 `~/.claude/agents/` 디렉토리에 배치.

### Agent Teams
여러 Claude Code 인스턴스가 **동시에** 서로 다른 작업을 수행:
- 리드 에이전트가 서브태스크 분배
- 백엔드 API · 프론트엔드 컴포넌트 · 문서 업데이트를 병렬 처리
- 결과 병합

### MCP (Model Context Protocol)
외부 데이터 소스 연결을 위한 오픈 표준. Claude Code에서 MCP 서버를 통해:
- Google Drive 문서 읽기
- Jira 티켓 업데이트
- Slack 메시지 조회
- 커스텀 툴링 연동

### Scheduled Tasks (예약 작업)
크론 스케줄로 자동 실행 — Anthropic 인프라에서 동작하므로 PC 꺼져도 실행됨.
- 아침 PR 리뷰
- 야간 CI 실패 분석
- 주간 의존성 감사

### Memory (메모리)
파일 기반 영속 메모리 — 대화 간에도 사용자 선호·프로젝트 컨텍스트를 유지.
`~/.claude/projects/<project>/memory/` 디렉토리에 마크다운 파일로 저장.

---

## CLI 명령어 (터미널)

### 기본 실행
| 명령어 | 설명 |
|--------|------|
| `claude` | 대화형 세션 시작 |
| `claude "프롬프트"` | 프롬프트를 전달하며 세션 시작 |
| `claude -p "질문"` | 비대화형 일회성 질문 (파이프 가능) |
| `claude -c` | 가장 최근 세션 이어서 계속 |
| `claude -r <session-id>` | 특정 세션 재개 |

### 모델·프롬프트 플래그
| 플래그 | 설명 |
|--------|------|
| `--model <모델>` | 사용 모델 지정 (`opus`, `sonnet`, `haiku`) |
| `--system-prompt "텍스트"` | 시스템 프롬프트 전체 교체 |
| `--system-prompt-file <파일>` | 파일에서 시스템 프롬프트 로드 |
| `--append-system-prompt "텍스트"` | 기본 프롬프트에 추가 지시 덧붙이기 |
| `--permission-mode` | 권한 모드 지정 |

### 출력·포맷 플래그
| 플래그 | 설명 |
|--------|------|
| `--output-format json` | JSON 형식 출력 (비대화형) |
| `--output-format stream-json` | 스트리밍 JSON 출력 |
| `--output-format text` | 텍스트만 출력 |
| `--max-turns <N>` | 최대 턴 수 제한 |
| `--verbose` | 상세 로그 출력 |

### 서브커맨드
| 명령어 | 설명 |
|--------|------|
| `claude auth login` | 로그인 / 계정 전환 |
| `claude auth status` | 현재 인증 상태 확인 |
| `claude auth logout` | 로그아웃 |
| `claude mcp add <서버>` | MCP 서버 추가 |
| `claude mcp remove <서버>` | MCP 서버 제거 |
| `claude mcp list` | MCP 서버 목록 |
| `claude mcp serve` | Claude Code를 MCP 서버로 노출 |
| `claude config set <key> <val>` | 설정 값 변경 |
| `claude config get <key>` | 설정 값 조회 |
| `claude config list` | 전체 설정 출력 |
| `claude update` | 최신 버전으로 업데이트 |

---

## 슬래시 명령어 (세션 내)

> 세션 중 `/`를 입력하면 사용 가능한 전체 명령어 목록 표시.

### 세션 관리
| 명령어 | 설명 |
|--------|------|
| `/help` | 사용 가능한 전체 명령어 표시 |
| `/clear` | 대화 기록 전체 삭제 (파일 수정은 유지) |
| `/compact [지시]` | 대화 기록을 요약 압축. 인자로 보존할 정보 지정 가능 |
| `/exit` | 세션 종료 |
| `/resume` | 이전 세션 재개 |
| `/export` | 대화를 파일 또는 클립보드로 내보내기 |

### 모델·비용
| 명령어 | 설명 |
|--------|------|
| `/model <모델>` | 모델 전환 (예: `/model haiku`) |
| `/cost` | 현재 세션 토큰 사용량·비용 표시 |
| `/effort` | 추론 노력 수준 조절 |

### 프로젝트·설정
| 명령어 | 설명 |
|--------|------|
| `/init` | 프로젝트 CLAUDE.md 파일 생성 |
| `/memory` | CLAUDE.md 파일 열기·편집 |
| `/config` | settings.json 설정 인터페이스 |
| `/permissions` | 권한 설정 관리 |
| `/add-dir` | 추가 작업 디렉토리 등록 |
| `/context` | 현재 컨텍스트 사용량 시각화 |

### 에이전트·MCP
| 명령어 | 설명 |
|--------|------|
| `/agents` | 서브에이전트 목록·생성·관리 |
| `/mcp` | MCP 서버 연결 상태·도구 확인 |
| `/hooks` | Hook 설정 관리 |

### 개발·디버깅
| 명령어 | 설명 |
|--------|------|
| `/doctor` | 설치 상태 건강 검진 |
| `/bug` | Anthropic에 버그 리포트 |
| `/diff` | 세션 중 변경 사항 인터랙티브 diff 뷰어 |
| `/status` | 현재 상태 정보 |
| `/ide` | IDE 통합 관리 |

### 인터페이스
| 명령어 | 설명 |
|--------|------|
| `/vim` | Vim 키바인딩 모드 토글 |
| `/output-style` | 출력 스타일 변경 |
| `/terminal-setup` | 터미널 설정 (Option+Enter 줄바꿈 등) |
| `/keybindings` | 키보드 단축키 설정 파일 열기 |
| `/color` | 터미널 색상 설정 |

### Git·협업
| 명령어 | 설명 |
|--------|------|
| `/pr-comments` | PR 코멘트 조회 |
| `/release-notes` | 릴리스 노트 생성 |
| `/install-github-app` | GitHub 앱 설치 |

### 계정
| 명령어 | 설명 |
|--------|------|
| `/login` | 계정 전환 |
| `/logout` | 로그아웃 |

### 빌트인 스킬 (슬래시 명령어로 호출)
| 명령어 | 설명 |
|--------|------|
| `/simplify` | 변경 코드의 재사용성·품질 검토 후 개선 |
| `/commit` | 변경 분석 → 커밋 메시지 생성 → 커밋 |
| `/review` | 코드 리뷰 (3-에이전트 파이프라인) |
| `/batch` | 대규모 변경을 병렬 워크트리에서 실행 |
| `/loop <간격> <명령>` | 일정 주기 프롬프트 반복 (기본 10분) |
| `/debug` | 디버깅 지원 |
| `/claude-api` | Anthropic API/SDK 코드 작성 지원 |
| `/schedule` | 원격 예약 에이전트 생성·관리 |
| `/plan` | Plan 모드 전환 (변경 전 승인 요청) |

> 커스텀 슬래시 명령어는 [[03-Claude Skills|Claude Skills]] 시스템으로 무제한 확장 가능.

---

## 키보드 단축키

| 단축키 | 설명 |
|--------|------|
| `Enter` | 메시지 전송 |
| `Shift+Enter` 또는 `Option+Enter` | 줄바꿈 |
| `Shift+Tab` | Plan 모드 진입 |
| `Esc` × 2 | Rewind 메뉴 (이전 상태 복원) |
| `Ctrl+C` | 현재 작업 중단 |
| `Ctrl+C` × 2 | 강제 종료 |
| `Ctrl+F` × 2 (3초 내) | 모든 백그라운드 에이전트 종료 |
| `Ctrl+A` / `Ctrl+E` | 줄 시작 / 끝 |
| `Option+F` / `Option+B` | 단어 앞/뒤 이동 |
| `Ctrl+W` | 이전 단어 삭제 |

> `~/.claude/keybindings.json`에서 커스텀 키바인딩 설정 가능. 변경 시 재시작 불필요.

---

## 권한 모드

| 모드 | 설명 |
|------|------|
| **Default** | 위험한 작업 전 사용자 승인 요청 |
| **Auto** | 안전한 작업 자동 승인, 위험 작업만 확인 |
| **Full Auto** | 모든 작업 자동 승인 (주의 필요) |

---

## 관련 노트
- [[00-OverView|Claude Overview]]
- [[01-Models|Claude Models]]
- [[03-Claude Skills|Claude Skills]]
- [[04-Claude Cowork|Claude Cowork]]

---

> 이 노트는 Claude Code로 작성되었습니다. 
> 무단 배포를 금지합니다.
