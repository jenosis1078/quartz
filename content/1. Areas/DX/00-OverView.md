---
type: note
area: DX
source: "https://claude.com"
created: 2026-04-04
tags: [topic/dx, topic/llm, type/note, source/anthropic]
status: done
---

# Claude — Overview

> Anthropic이 개발한 AI 어시스턴트.
> 정보 이론의 아버지 **Claude Shannon**의 이름에서 유래.

## 정의

Claude는 Anthropic이 만든 대규모 언어 모델(LLM) 시리즈이자, 그 위에 구축된 AI 어시스턴트 제품군이다.
Transformer 아키텍처 기반으로, **Constitutional AI(CAI)** 라는 독자적 학습 방식을 통해 안전성과 성능을 동시에 추구한다.

---

## 만든 사람 - Anthropic

| 항목 | 내용 |
|------|------|
| 설립 | 2021년 |
| 본사 | 미국 샌프란시스코 |
| CEO | **Dario Amodei** (前 OpenAI VP of Research) |
| 대표 | **Daniela Amodei** (前 OpenAI VP of Safety & Policy) |
| 공동 창립 | Tom Brown, Chris Olah, Sam McCandlish, Jack Clark, Jared Kaplan 등 |
| 미션 | 안전하고 조종 가능한(steerable) AI 시스템 개발 |

Dario·Daniela 형제를 포함한 OpenAI 핵심 연구진이 **AI 안전성에 대한 우려**와 Microsoft 파트너십 방향 차이로 2020~2021년 독립하여 설립.

---

## 역사

### 2021 — 창립
Anthropic 설립. Constitutional AI 논문 준비.

### 2022 — 내부 개발
Claude 첫 버전 학습 완료. 안전성 테스트를 위해 **공개하지 않음**.
Constitutional AI 논문 발표 (*"Constitutional AI: Harmlessness from AI Feedback"*).

### 2023 — 첫 공개
- **Mar** — **Claude 1** 출시. CAI 기반 첫 프로덕션 모델.
- **Jul** — **Claude 2** 출시. 일반 사용자 공개. 컨텍스트 100K 토큰.
- **Nov** — **Claude 2.1** 출시. 컨텍스트 200K 토큰으로 확대.

### 2024 — 3-Tier 체계 확립
- **Mar** — **Claude 3** (Haiku / Sonnet / Opus) 출시. 비전 기능 도입.
- **Jun** — **Claude 3.5 Sonnet** — 상위 모델 Opus 3를 능가하는 성능.
- **Oct** — **Claude 3.5 Sonnet v2** + **Haiku 3.5**. **Computer Use** 최초 도입.

### 2025 — Extended Thinking & Claude 4
- **Feb** — **Claude 3.7 Sonnet** — **Extended Thinking** 최초 도입. 하이브리드 추론.
- **May** — **Claude 4** (Sonnet 4 / Opus 4) 출시. 프로급 코딩 성능.
- **Oct** — **Haiku 4.5** 출시. Sonnet 4 수준 성능을 경량 모델로 달성.
- **Nov** — **Claude 4.5** (Sonnet 4.5 / Opus 4.5). 가격 67% 인하, 1M 컨텍스트 베타.

### 2026 — 1M 컨텍스트 & Agent Teams
- **Jan** — **[[04-Claude Cowork|Claude Cowork]]** 리서치 프리뷰 출시.
- **Feb** — **Claude 4.6** (Sonnet 4.6 / Opus 4.6). 1M 컨텍스트 GA, Agent Teams 도입.

---

## 아키텍처

![[claude-architecture.svg|697]]

### 학습 파이프라인

**Phase 0 — Pre-training**
대규모 텍스트 코퍼스로 Transformer 사전학습 → Base Model 생성.
Next Token Prediction 방식으로 언어의 통계적 패턴을 학습.

**Phase 1 — Supervised Learning (Constitutional AI)**
1. 유해 프롬프트에 대한 응답을 생성
2. **헌법(Constitution)** 원칙에 따라 AI가 스스로 비평(Critique)
3. 비평을 반영하여 응답 수정(Revision)
4. 수정된 응답으로 Supervised Fine-tuning

> 2026년 버전 헌법은 약 23,000 단어. 철학자 Amanda Askell이 주저자.

**Phase 2 — RLAIF (Reinforcement Learning from AI Feedback)**
1. 응답 쌍(pair) 생성
2. AI가 헌법 기준으로 더 나은 응답 선택
3. 이 선호 데이터로 **Preference Model(보상 모델)** 학습
4. PPO/DPO 기반 RL Fine-tuning

> 기존 RLHF(사람 피드백)와 달리 **AI 피드백**을 사용 → 확장 가능한 안전성(Scalable Oversight).

---

## 제품 에코시스템

![[claude-product-ecosystem.svg|697]]

| 제품                    | 대상     | 설명                               |
| --------------------- | ------ | -------------------------------- |
| **claude.ai**         | 일반 사용자 | 웹 채팅 인터페이스                       |
| **Claude Desktop**    | 일반 사용자 | macOS / Windows 데스크톱 앱           |
| **[[02-Claude Code|Claude Code]]**   | 개발자    | 터미널 CLI / IDE 확장 — 에이전틱 코딩       |
| **[[04-Claude Cowork|Claude Cowork]]** | 지식 근로자 | 데스크톱 에이전트 — 멀티스텝 업무 자동화          |
| **API**               | 개발자    | `platform.claude.com` — 모델 직접 호출 |

---

## 구독 플랜

| 플랜 | 가격 | 대상 |
|------|------|------|
| **Free** | 무료 | 기본 사용 |
| **Pro** | $20/월 ($17 연간) | 개인 파워유저 |
| **Max** | $100~/월 | Pro 한도 초과 사용자 |
| **Team** | $25~/user/월 | 팀 협업 |
| **Enterprise** | 커스텀 | 대규모 조직 |

---

## 경쟁 비교

| 항목 | Claude (Anthropic) | GPT (OpenAI) | Gemini (Google) |
|------|-------------------|--------------|-----------------|
| 최대 컨텍스트 | 1M tokens | 128K tokens | 2M tokens |
| 안전성 접근 | Constitutional AI | RLHF | RLHF + 필터 |
| 코딩 도구 | [[02-Claude Code|Claude Code]] | Codex CLI | Jules |
| 데스크톱 에이전트 | [[04-Claude Cowork|Claude Cowork]] | Operator | Project Mariner |
| 강점 | 코딩·추론·장문 분석 | 범용·생태계 | 멀티모달·검색 연동 |

---

## 관련 노트
- [[01-Models|Claude Models]]
- [[02-Claude Code|Claude Code]]
- [[03-Claude Skills|Claude Skills]]
- [[04-Claude Cowork|Claude Cowork]]

---

> 이 노트는 Claude Code로 작성되었습니다. 
> 무단 배포를 금지합니다.
