---
type: article
title: "AI 에이전트 프레임워크 비교 LangGraph CrewAI Swarm"
author: "Yi Zhang (Co-founder, Relari.ai)"
url: "https://blog.nuvi.dev/choosing-the-right-ai-agent-framework-langgraph-vs-crewai-vs-openai-swarm-56f7931b4249"
source: "Medium (Nuvi Blog / Relari Blog)"
date: 2024-12-03
created: 2026-03-25
date_read: 2026-03-25
tags: [type/article, source/medium, topic/llm, topic/ai-agent, topic/mlops, status/done]
---
# AI 에이전트 프레임워크 비교: LangGraph vs CrewAI vs OpenAI Swarm

> 저자: Yi Zhang (Relari.ai 공동 창업자)
> 출처: Medium · Nuvi Blog (구 Relari Blog) · 2024년 12월 3일
> 동일한 Agentic Finance App을 3개 프레임워크로 구현해 비교한 실전 분석

## 요약

동일한 금융 에이전트 앱을 LangGraph·CrewAI·OpenAI Swarm으로 각각 구현하여 통제성·유연성·단순성을 실전 비교.

## 핵심 포인트

- LangGraph: 가장 높은 통제성과 상태 관리 강점
	- 러닝 커브 높음 — 복잡한 프로덕션에 적합
- CrewAI: 역할 기반 멀티에이전트 추상화
	- 빠른 프로토타이핑 가능, 커스터마이징 제한적
- OpenAI Swarm: 가장 단순한 API
	- 실험적 수준 — 현시점 프로덕션 미적합

## 인사이트

프레임워크 선택은 "통제 vs 속도"의 트레이드오프다. 프로토타입이면 CrewAI, 프로덕션 수준의 관찰 가능성과 오류 복구가 필요하면 LangGraph. 프레임워크를 먼저 고르지 말고, 요구사항(관찰 가능성·복잡도·속도)을 먼저 정의하라.

---

## 핵심 내용

### AI 에이전트란?

LLM 기반으로 **환경과 독립적으로 상호작용하고 실시간으로 의사결정**하는 시스템.
기존 LLM 파이프라인(A→B→C 고정 흐름)과 달리, 에이전트는 **도구(tools)**를 활용해 상황에 따라 동적으로 다음 단계를 결정한다.

에이전트 구현의 주요 과제:
- 태스크 간 상태(state)·메모리 관리
- 여러 서브 에이전트 조율 및 통신
- 안정적인 툴 콜링 및 에러 처리
- 대규모 추론·의사결정 처리

---

### 3개 프레임워크 개요
![[에이전트 프레임워크.webp]]
![[다중 에이전트 아키텍처.webp]]

| 프레임워크 | 핵심 철학 | 특징 |
|-----------|----------|------|
| **LangGraph** | 그래프 기반 오케스트레이션 | 프로덕션용, 커스터마이징 강력, 복잡도 높음 |
| **CrewAI** | 역할 기반 협업 | 시작 쉬움, 직관적, 커스터마이징 제한적 |
| **OpenAI Swarm** | 루틴 기반 프롬프팅 | 경량/미니멀리스트, "교육용" 수준, DIY 필요 |

> **기타 주목할 프레임워크**
> - **LlamaIndex Workflow**: 이벤트 드리븐, 보일러플레이트 코드 많음 (개선 중)
> - **AutoGen (Microsoft)**: 멀티 에이전트 대화 조율, v0.2→v0.4 이벤트 드리븐으로 전면 재작성 중

---

### 벤치마크 앱: Agentic Finance Assistant

**Supervisor 아키텍처**로 동일한 앱을 3개 프레임워크로 구현:

![[1_I6bDSJ5Pv_QsvjKznORdxA 1.webp]]

```
Supervisor Agent
├── Financial Data Agent  → FMP API로 재무 데이터 수집
├── Web Research Agent    → 웹 페이지 크롤링·정보 추출
└── Output Summarizing Agent → 최종 결과 통합·정리
```

![[0__pB1Rq7LAnEZs1b6.webp]]

![[0_tTrheeq8v0yo7hMK.webp]]

처리 가능한 쿼리 예시:
- *"Spirit 항공의 재무 건전성을 경쟁사와 비교해줘"*
- *"Apple의 최고 수익 제품 라인은? 마케팅은 어떻게 하고 있어?"*
- *"시가총액 $5bn 이하이면서 매출 성장률 20% YoY 이상인 소비재 주식 찾아줘"*

---

### 비교 분석: 4가지 차원

#### 1. 에이전트·툴 정의

| | LangGraph | CrewAI | OpenAI Swarm |
|--|-----------|--------|--------------|
| 에이전트 정의 | 상태를 유지하는 노드 | Agent(role, goal, backstory) + Task | Agent(instructions=루틴) |
| 툴 통합 | `@tool` 데코레이터 또는 `BaseTool` 서브클래싱 | 동일 방식 | 함수 직접 전달 |

- **LangGraph**: `create_react_agent`로 간단히 생성, 내부는 그래프로 구조화
- **CrewAI**: `role`, `goal`, `backstory` 필수 정의 → 구조적이지만 반복적
- **Swarm**: 시스템 프롬프트에 "Routines"(단계별 지시)로 흐름 정의 → 강력한 LLM 필요

#### 2. 오케스트레이션

| | LangGraph | CrewAI | OpenAI Swarm |
|--|-----------|--------|--------------|
| 방식 | 그래프 노드·엣지 명시적 정의 | `Crew` + `Process.hierarchical` | Handoff 함수 (에이전트를 툴로) |
| 엣지 종류 | Regular(결정론적) + Conditional(LLM 판단) | 프레임워크가 관리 | 암묵적(transfer 함수) |

- **LangGraph**: `AgentState`로 공유 상태 스키마 명시, `StateGraph`로 워크플로 빌드
- **CrewAI**: `allow_delegation=True` + `Process.hierarchical`로 오케스트레이션 자동화
- **Swarm**: `transfer_to_X()` 함수로 에이전트 간 핸드오프, 깔끔하지만 규모 커지면 의존성 추적 어려움

#### 3. 메모리

| | LangGraph | CrewAI | OpenAI Swarm |
|--|-----------|--------|--------------|
| 단기 메모리 | `MemorySaver` + `checkpointer` | ChromaDB vectorstore (자동) | 없음 (메시지 히스토리만) |
| 장기 메모리 | `InMemoryStore` (→ DB 백엔드 가능) | SQLite db (자동) | 없음 (서드파티 통합 필요) |
| 특이사항 | thread_id로 대화 분리 | 장기 메모리는 task 설명 일치 필요 (엄격) | mem0 등 외부 연동 |

CrewAI `memory=True` 설정 시 자동 생성되는 저장소:
- Short-term: ChromaDB (실행 히스토리)
- Most recent: SQLite (최근 태스크 결과)
- Long-term: SQLite (누적 결과)
- Entity memory: ChromaDB (핵심 엔티티·관계)

#### 4. Human-in-the-loop

| | LangGraph | CrewAI | OpenAI Swarm |
|--|-----------|--------|--------------|
| 방식 | 그래프에 `interrupt_before` 브레이크포인트 설정 | `human_input=True` 플래그 | 없음 (human을 툴/에이전트로 추가) |
| 유연성 | 커스텀 브레이크포인트 자유롭게 설정 가능 | 에이전트 실행 후 피드백 요청만 지원 | 직접 구현 필요 |

---

### 기능 비교 요약표

![[1_TVka-rR7OnaG1fc4uQg6nQ.webp]]

| 항목 | LangGraph | CrewAI | OpenAI Swarm |
|------|-----------|--------|--------------|
| 핵심 철학 | 그래프 기반 오케스트레이션 | 역할 기반 협업 | 루틴 기반 프롬프팅 |
| 에이전트 정의 | 상태 유지 노드 | 기술+태스크가 있는 에이전트 | 루틴+함수가 있는 에이전트 |
| 툴 통합 | 데코레이터/BaseTool | 데코레이터/BaseTool | 함수 직접 호출 |
| 상태 관리 | 명시적 정의 | 프레임워크 관리 | 메시지 히스토리 |
| 핸드오프 | 엣지 | 프레임워크 관리 | 에이전트-as-a-툴 |
| 메모리 | 단/장기 커스터마이징 가능 | vectorstore+SQLite 내장 | 없음 (N/A) |
| Human-in-the-loop | 커스텀 브레이크포인트 | 실행 후 피드백 요청 | 없음 (human-as-a-tool) |

---

### 프레임워크 선택 가이드 (Decision Tree)

```
어떤 유형의 에이전트 앱인가?
│
├─ 복잡한 멀티스텝 워크플로
│   ├─ 에이전트 제어 세밀하게 필요? Yes → LangGraph or CrewAI
│   └─ No → Swarm (DIY)
│
├─ 단순/순차 태스크
│   └─ 프레임워크 코드 최소화? Yes → Swarm / No → LangGraph
│
└─ 협업형 멀티 에이전트
    ├─ 스킬 기반 태스크 분배 → CrewAI
    └─ 워크플로 기반 분배
        └─ 프레임워크 기능 선호 → LangGraph / 유연성 선호 → Swarm
```

**요약 추천:**

![[1_zZsMcyy75YKgISFLtGkWKQ.webp]]

- **LangGraph** → 프로덕션 수준, 복잡한 워크플로, 상태 관리가 중요한 경우
- **CrewAI** → 빠른 프로토타이핑, 역할 분담이 명확한 멀티 에이전트
- **Swarm** → 간단한 유즈케이스, 기존 LLM 파이프라인에 에이전트 흐름을 추가할 때

---

## 인상적인 부분

- **같은 앱을 3개 프레임워크로 구현**해 비교한 점이 매우 실용적 - 추상적 비교가 아닌 코드 레벨 차이를 직접 확인 가능
- Swarm의 "anti-framework" 접근법: 코드에 로직을 쓰는 대신 **시스템 프롬프트(Routines)에 흐름을 정의** → 강력한 LLM이 있을 때는 오히려 깔끔
- CrewAI의 `memory=True` 한 줄이 4가지 메모리 저장소를 자동으로 생성한다는 점 - 편리하지만 내부 동작을 모르면 블랙박스

## 내 생각 / 적용 아이디어

- 현재 딥러닝 관련 작업에서 에이전트를 도입한다면 **LangGraph**가 적합 - 상태 관리와 디버깅이 명확
- CrewAI는 **데이터 수집 → 분석 → 리포트 생성** 같은 파이프라인에 빠르게 적용 가능
- Swarm은 기존 OpenAI API 기반 코드에 에이전트 흐름을 추가할 때 진입 장벽이 낮음
- Part 2 (성능 벤치마크, 관찰가능성) 후속 아티클도 읽을 것

## 관련 노트

- [[(260312)딥러닝 라이브러리 비교]]
- [[(250911)NPU AI혁명을 이끄는 뇌 닮은 칩]]

---

> 이 노트는 Claude Code로 작성되었습니다. 무단 배포를 금지합니다.
