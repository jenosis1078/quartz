---
type: permanent-note
source: "Daily/(260405)학습 일지"
created: 2026-04-05
tags: [type/idea, topic/dx, topic/llm, topic/consulting]
---

# Claude Code로 현황분석 산출물 파이프라인 구축하기

> 인터뷰 텍스트를 넣으면 이슈 분류표와 우선순위 매트릭스가 나온다면?

![[idea-current-analysis-pipeline.svg|697]]

## 아이디어

현황분석 단계에서 반복되는 작업(인터뷰 정리 → 이슈 도출 → 분류 → PPT 표/매트릭스 작성)을 Claude Code 커스텀 스킬로 자동화한다.

- `/analyze-interview` — 인터뷰 텍스트에서 pain point 추출, 이슈 분류
- `/issue-matrix` — 이슈 목록을 Impact × Urgency 매트릭스로 변환
- `/gen-deliverable` — 분석 결과를 PPT용 마크다운 표/차트로 출력

**핵심 발상**
	컨설턴트가 반복하는 "텍스트 → 구조화된 표" 변환은 LLM이 가장 잘하는 작업이다. 
	판단(이 이슈가 왜 중요한가)은 컨설턴트가, 구조화(표 만들기)는 AI가 담당한다.

## 구현 방향

### 스킬 1: `/analyze-interview`

```markdown
---
name: analyze-interview
description: "인터뷰 텍스트에서 이슈를 추출·분류"
trigger: /analyze-interview
model: opus
---

## Instructions
1. 인터뷰 텍스트를 읽고 핵심 pain point를 추출
2. 각 이슈를 다음 카테고리로 분류:
   - 조직/인력, 프로세스, 시스템/인프라, 데이터, 보안
3. 이슈별 심각도(H/M/L)를 판단 근거와 함께 기재
4. 마크다운 표로 출력
```

### 스킬 2: `/issue-matrix`

```markdown
---
name: issue-matrix
description: "이슈 목록을 우선순위 매트릭스로 변환"
trigger: /issue-matrix
---

## Instructions
1. 이슈 목록을 Impact(영향도) × Urgency(긴급도) 2x2 매트릭스로 배치
2. 각 사분면별 권고 사항 작성
3. Quick Win / Strategic / Monitor / Low Priority로 라벨링
```

### 스킬 3: `/gen-deliverable`

```markdown
---
name: gen-deliverable
description: "분석 결과를 PPT용 산출물로 변환"
trigger: /gen-deliverable
---

## Instructions
1. 입력된 분석 결과를 PPT 복사 가능한 마크다운 표로 변환
2. Gap Analysis 표 (As-Is vs To-Be) 포함
3. 요약 슬라이드용 bullet point 3~5개 생성
```

### Hooks 연동

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "command": "echo 'Deliverable generated — review before client submission'"
      }
    ]
  }
}
```

## 산출물 예시

| 이슈 ID | 카테고리 | 이슈 내용 | 심각도 | Impact | Urgency | 우선순위 |
|---------|---------|----------|--------|--------|---------|---------|
| ISS-01 | 시스템 | 레거시 ERP 노후화 | H | H | H | Quick Win |
| ISS-02 | 데이터 | 부서 간 데이터 사일로 | H | H | M | Strategic |
| ISS-03 | 프로세스 | 수작업 보고 체계 | M | M | H | Quick Win |

## 근거 / 출처

- [[02-Claude Code|Claude Code]]
	- 커스텀 스킬, Hooks, Extended Thinking
- [[03-Claude Skills|Claude Skills]]
	- SKILL.md 작성 가이드, $ARGUMENTS 치환
- ISP/ISMP 방법론
	- 현황분석 → 이슈 도출 → Gap Analysis

## 반론 / 한계

- **컨설턴트의 맥락 판단 대체 불가**
	- 정치적 맥락, 고객 뉘앙스, 비공식 정보는 LLM이 알 수 없음
- **프로젝트마다 산출물 포맷 상이**
	- 고객사·PMO 요구에 따라 스킬을 매번 수정해야 함
- **인터뷰 품질 의존**
	- 인터뷰 기록이 부실하면 이슈 추출 품질도 떨어짐
- **보안 문제**
	- 고객사 내부 정보를 외부 LLM API에 전송하는 것에 대한 보안 검토 필요

## 연결 노트

- [[(260405)학습 일지]]
- [[02-Claude Code|Claude Code]]
- [[03-Claude Skills|Claude Skills]]
- [[(260405)Cowork로 ISP 환경분석 자동화하기]]
- [[(260405)Constitutional AI 방식을 IT 거버넌스 평가에 적용하기]]

---

> 이 노트는 Claude Code로 작성되었습니다. 
> 무단 배포를 금지합니다.
