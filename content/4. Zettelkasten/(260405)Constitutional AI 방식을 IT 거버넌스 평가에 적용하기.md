---
type: permanent-note
source: "Daily/(260405)학습 일지"
created: 2026-04-05
tags: [type/idea, topic/llm, topic/consulting, topic/ai-safety]
---

# Constitutional AI 방식을 IT 거버넌스 평가에 적용하기

> EA 원칙을 "헌법"으로, LLM의 자기 비평을 "품질 게이트"로 활용한다면?

![[idea-cai-governance.svg|697]]

## 아이디어

Anthropic의 Constitutional AI 방식(헌법 원칙 → 자기 비평 → 수정)을 목표모델 설계 품질 검증에 차용한다.

고객사의 EA 원칙이나 IT 전략 방향을 "헌법(Constitution)"으로 정의하고, LLM이 작성한 목표모델 초안을 스스로 평가·수정하게 하는 **자동 품질 게이트**를 만든다.

**핵심 발상**: Constitutional AI에서 23,000단어 헌법이 실제로 작동한다는 것은, IT 거버넌스 원칙(보통 10~20개 항목)으로도 충분히 자기 평가가 가능하다는 의미다.

## 패턴 대응

| Constitutional AI | IT 거버넌스 평가 |
|-------------------|----------------|
| Constitution (헌법) | EA Principles / IT 전략 방향 |
| Self-Critique (자기 비평) | LLM이 목표모델 초안을 원칙 기준으로 평가 |
| Revision (수정) | 위반 사항 자동 수정 후 재출력 |
| Human Review | 컨설턴트 최종 검토 |

## 구현 방향

### Step 1: IT Constitution 작성

```markdown
# 고객사 IT Constitution (예시)

1. Cloud-First: 신규 시스템은 클라우드 우선 검토
2. Reuse over Build: 기존 시스템/솔루션 재활용 우선
3. Data Governance: 데이터 표준·품질 관리 체계 준수
4. Security by Design: 설계 단계부터 보안 내재화
5. API-First Integration: 시스템 간 연계는 API 기반
6. Single Source of Truth: 동일 데이터의 중복 저장 금지
7. User-Centric Design: 사용자 경험 중심 설계
```

### Step 2: Auto Review Prompt

```
당신은 IT 아키텍처 검토자입니다.
아래 IT Constitution에 따라 목표모델 초안을 평가하세요.

[IT Constitution 삽입]

각 원칙별로:
1. 준수 여부 (Pass / Fail / Partial)
2. 위반 사항 구체적 지적
3. 수정 권고안

평가 후 위반 사항을 반영하여 수정된 목표모델을 출력하세요.
```

### Step 3: Quality Gate Workflow

```
LLM이 목표모델 초안 작성
    ↓
IT Constitution 기준 자동 평가 (Self-Critique)
    ↓
위반 사항 자동 수정 (Revision)
    ↓
컨설턴트 최종 검토 (Human Review)
    ↓
고객 제출용 산출물
```

## 평가 산출물 예시

| 원칙 | 판정 | 지적 사항 | 수정 권고 |
|------|------|----------|----------|
| Cloud-First | Pass | - | - |
| Reuse over Build | Fail | 신규 CRM 자체 개발 제안 | SaaS 솔루션(Salesforce 등) 우선 검토 권고 |
| Data Governance | Partial | 데이터 표준 언급 없음 | 데이터 표준 관리 체계 절 추가 필요 |
| Security by Design | Pass | - | - |
| API-First | Fail | 레거시 DB 직접 연계 설계 | API Gateway 도입 검토 |

## 근거 / 출처

- [[00-OverView|Claude Overview]]
	- Constitutional AI 파이프라인(SL Phase → RLAIF), 23,000단어 헌법 사례
- TOGAF Architecture Principles
	- EA 원칙이 이미 "헌법" 역할과 구조적으로 유사
- ISP 목표모델 설계
	- 아키텍처 원칙 준수 검증은 필수 단계

## 반론 / 한계

- **추상적 원칙 = 추상적 평가**
	- "Cloud-First"처럼 해석 여지가 큰 원칙은 LLM 평가도 모호해짐. 
	- 구체적 기준(예: "월 비용 X 이하 시스템은 SaaS 필수")이 필요
- **공공 사업 감리 기준과 이중 구조**
	- 감리 체크리스트가 별도로 존재하므로, 이 품질 게이트가 추가 부담이 될 수 있음
- **LLM의 도메인 한계**
	- 특정 산업(금융 규제, 의료 인증 등)의 세부 원칙은 범용 LLM이 정확히 판단하기 어려움
- **고객 설득**
	- "AI가 검토했다"는 것이 고객에게 신뢰를 주는지, 오히려 불안을 주는지는 고객마다 다름

## 연결 노트

- [[(260405)학습 일지]]
- [[00-OverView|Claude Overview]]
- [[(260405)Claude Code로 현황분석 산출물 파이프라인 구축하기]]

---

> 이 노트는 Claude Code로 작성되었습니다.
> 무단 배포를 금지합니다.
