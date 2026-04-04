---
type: permanent-note
source: "Daily/(260405)학습 일지"
created: 2026-04-05
tags: [type/idea, topic/dx, topic/llm, topic/consulting]
---

# Cowork로 ISP 환경분석 자동화하기

> 프로젝트 킥오프 전에 환경분석 초안이 이미 만들어져 있다면?

![[idea-isp-env-automation.svg|697]]

## 아이디어

ISP 초기 단계에서 가장 시간이 드는 환경분석(기술 트렌드, 벤치마킹, 규제 동향)을 Cowork의 `/schedule` + MCP 커넥터로 자동 수집한다.
매주 월요일 자동으로 "AI/클라우드/보안/데이터 트렌드 요약 보고서"가 생성되어 Google Drive에 저장되는 구조.

**핵심 발상**: 환경분석은 반복적이고 정형화된 리서치다. 컨설턴트의 판단이 필요한 것은 "해석"이지 "수집"이 아니다. 수집은 자동화하고, 컨설턴트는 해석에 집중한다.

## 구현 방향

```
Cowork /schedule (매주 월요일 09:00)
    ↓ MCP Web Search
기술 트렌드 / 벤치마크 / 규제 동향 수집
    ↓ Agent Analysis
PEST 분류, SWOT 매핑, 핵심 이슈 추출
    ↓ /docx 또는 /pptx
환경분석 초안 보고서 생성
    ↓ MCP Google Drive
자동 업로드 → 컨설턴트 리뷰
```

### 자동 수집 가능 영역

| 영역 | 수집 대상 | MCP 커넥터 |
|------|----------|-----------|
| 기술 트렌드 | Gartner Hype Cycle, 주요 벤더 릴리스 | Web Search |
| 벤치마킹 | 동종 업계 IT 투자 현황, 디지털 전환 사례 | Web Search |
| 규제 동향 | 개인정보보호법, 클라우드 보안 인증, AI 규제 | Web Search |
| 내부 문서 | 기존 ISP 보고서, IT 전략 문서 | Google Drive |

### 기대 효과

- **Before**
	- 환경분석 리서치 2~3주 → 컨설턴트가 직접 검색·정리
- **After**
	- 자동 주간 보고서 + 컨설턴트 리뷰 2~3일

## 근거 / 출처

- [[04-Claude Cowork|Claude Cowork]] 
	- 예약 작업, MCP 커넥터 12종, `/docx` `/pptx` 빌트인 스킬
- [[00-OverView|Claude Overview]] 
	- Cowork는 Claude Code와 동일한 에이전틱 아키텍처
- ISP 방법론
	- 환경분석 단계(PEST, SWOT, 벤치마킹)

## 반론 / 한계

- **공공 ISP 양식 준수**
	- EA, TOGAF 등 특정 프레임워크 양식이 필요 — 범용 요약으로 부족할 수 있음
- **고객사 내부 자료 접근 불가**
	- NDA 자료, 내부 시스템 현황은 MCP로 수집 불가
- **Pro 이상 구독 필요**
	- Cowork + 예약 작업은 유료 플랜 전용
- **검색 품질 의존**
	- 키워드 설계가 나쁘면 수집 결과도 나쁨

## 연결 노트

- [[(260405)학습 일지]]
- [[04-Claude Cowork|Claude Cowork]]
- [[(260405)Claude Code로 현황분석 산출물 파이프라인 구축하기]]

---

> 이 노트는 Claude Code로 작성되었습니다. 
> 무단 배포를 금지합니다.
