---
type: note
area: DX
source: "https://platform.claude.com/docs/en/about-claude/models/overview"
created: 2026-04-04
tags: [topic/dx, topic/llm, type/note, source/anthropic]
status: done
---

# Claude Models

> Claude의 3-Tier 모델 체계 — Haiku(속도) · Sonnet(균형) · Opus(성능).
> 세대가 올라갈수록 성능은 높아지고 가격은 낮아지는 추세.

## 모델 패밀리 진화

![[claude-model-family.svg|697]]

---

## 현행 모델 (2026년 4월 기준)

### Opus 4.6 — 최고 성능
| 항목 | 스펙 |
|------|------|
| 출시일 | 2026-02-05 |
| 컨텍스트 | **1M tokens** (GA) |
| 최대 출력 | **128K tokens** |
| 가격 (per 1M) | $5 (입력) / $25 (출력) |
| Model ID | `claude-opus-4-6` |

- 심층 추론, 대규모 컨텍스트, 멀티에이전트 조율에 최적화
- **Agent Teams** 도입 — 여러 에이전트가 협업하는 워크플로우
- Extended Thinking 기본 활성화

### Sonnet 4.6 — 최적 균형
| 항목 | 스펙 |
|------|------|
| 출시일 | 2026-02-17 |
| 컨텍스트 | **1M tokens** (GA) |
| 최대 출력 | **64K tokens** |
| 가격 (per 1M) | $3 (입력) / $15 (출력) |
| Model ID | `claude-sonnet-4-6` |

- SWE-bench Verified **79.6%**, OSWorld **72.7%**
- 이전 세대 Opus를 능가하는 첫 번째 Sonnet — 코딩 평가에서 Opus 4.5 상회
- 에이전틱 검색 성능 향상, 토큰 소비 감소

### Haiku 4.5 — 최고 속도
| 항목 | 스펙 |
|------|------|
| 출시일 | 2025-10-15 |
| 컨텍스트 | **200K tokens** |
| 최대 출력 | **8K tokens** |
| 가격 (per 1M) | $1 (입력) / $5 (출력) |
| Model ID | `claude-haiku-4-5-20251001` |

- Sonnet 4 수준의 추론 능력을 경량 모델로 달성
- 밀리초 단위 응답 — 실시간 채팅, 분류, 경량 에이전트에 적합

---

## 세대별 비교

| 모델 | 출시 | 컨텍스트 | 출력 | 입력$/M | 출력$/M | 주요 도입 기능 |
|------|------|---------|------|---------|---------|--------------|
| Opus 3 | 2024-03 | 200K | 4K | $15 | $75 | 3-Tier 체계, 비전 |
| Sonnet 3 | 2024-03 | 200K | 4K | $3 | $15 | — |
| Haiku 3 | 2024-03 | 200K | 4K | $0.25 | $1.25 | — |
| Sonnet 3.5 | 2024-06 | 200K | 8K | $3 | $15 | Opus 3 능가 |
| Sonnet 3.5v2 | 2024-10 | 200K | 8K | $3 | $15 | **Computer Use** |
| Haiku 3.5 | 2024-10 | 200K | 8K | $1 | $5 | — |
| Sonnet 3.7 | 2025-02 | 200K | 64K | $3 | $15 | **Extended Thinking** |
| Opus 4 | 2025-05 | 200K | 32K | $15 | $75 | 프로급 코딩 |
| Sonnet 4 | 2025-05 | 200K | 16K | $3 | $15 | — |
| Haiku 4.5 | 2025-10 | 200K | 8K | $1 | $5 | ≈ Sonnet 4 성능 |
| Opus 4.5 | 2025-11 | 200K | 32K | $5 | $25 | 가격 67%↓ |
| Sonnet 4.5 | 2025-11 | 200K/1M(β) | 64K | $3 | $15 | 1M ctx 베타 |
| **Opus 4.6** | 2026-02 | **1M** | **128K** | $5 | $25 | **Agent Teams, 1M GA** |
| **Sonnet 4.6** | 2026-02 | **1M** | **64K** | $3 | $15 | **Opus 4.5 능가** |

> Batch API 사용 시 모든 모델 입·출력 **50% 할인**.

---

## Tier별 특성 비교

### Haiku — "속도와 비용"
```
용도: 실시간 분류, 경량 채팅, 대량 배치 처리
선택 기준: 응답 속도가 최우선, 비용 민감
트레이드오프: 복잡한 추론·창의성에서 한계
```

### Sonnet — "균형의 기술"
```
용도: 코딩 에이전트, RAG, 복잡한 분석, 일반 업무
선택 기준: 성능/비용 최적점, 대부분의 프로덕션 워크로드
트레이드오프: Opus 대비 극한 추론에서 소폭 열세
```

### Opus — "최대 성능"
```
용도: 심층 연구, 대규모 코드베이스 분석, 멀티에이전트 조율
선택 기준: 정확도·깊이가 최우선, 비용 여유
트레이드오프: 가장 높은 비용, 상대적으로 느린 응답
```

---

## 핵심 기능 도입 타임라인

| 기능 | 최초 도입 | 설명 |
|------|----------|------|
| **3-Tier 체계** | Claude 3 (2024-03) | Haiku/Sonnet/Opus 분리 |
| **Vision** | Claude 3 (2024-03) | 이미지 입력 처리 |
| **Computer Use** | Sonnet 3.5v2 (2024-10) | 컴퓨터 인터페이스 직접 조작 |
| **Extended Thinking** | Sonnet 3.7 (2025-02) | 답변 전 내부 추론 과정 |
| **1M Context** | Sonnet 4.5 β (2025-11) | 100만 토큰 입력 |
| **Agent Teams** | Opus 4.6 (2026-02) | 멀티에이전트 협업 |

---

## 가격 추세

![[claude-models-pricing.svg|697]]

---

## 모델 선택 가이드

```
시작 → 복잡한 추론이 필요한가?
        ├─ YES → 비용 제약이 있는가?
        │         ├─ YES → Sonnet 4.6
        │         └─ NO  → Opus 4.6
        └─ NO  → 실시간 응답이 필요한가?
                  ├─ YES → Haiku 4.5
                  └─ NO  → Sonnet 4.6
```

---

## 관련 노트
- [[00-OverView|Claude Overview]]
- [[02-Claude Code|Claude Code]]
- [[03-Claude Skills|Claude Skills]]
- [[04-Claude Cowork|Claude Cowork]]

---

> 이 노트는 Claude Code로 작성되었습니다. 무단 배포를 금지합니다.
