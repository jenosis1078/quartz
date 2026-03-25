---
type: permanent-note
source: "Daily/(260325)학습 일지"
created: 2026-03-25
tags: [type/idea, topic/rag, topic/obsidian, topic/llm]
---

# 내 Obsidian Vault로 RAG 챗봇 만들기

> 지금 쌓고 있는 노트들이 곧 나만의 지식 베이스가 된다.

![[idea-obsidian-rag.svg]]

## 아이디어

Obsidian에 쌓인 노트들을 RAG 파이프라인에 연결해서 "내가 배운 것들에 기반해서 답해주는 챗봇"을 만든다. "LangGraph가 뭐였더라?" 라고 물으면, 내가 직접 정리한 노트에서 답을 찾아준다.

**핵심 발상**: Obsidian 노트는 이미 청킹된 단위로 존재한다. 별도의 분할 작업 없이 노트 파일 하나가 곧 하나의 청크다.

## 구현 방향

```
Obsidian Vault (.md 파일들)
    ↓ LangChain 파서
청크 단위 텍스트
    ↓ OpenAI Embeddings
벡터 배열
    ↓ FAISS (로컬 저장)
벡터 DB
    ↓ 질문 입력 시 유사도 검색
관련 노트 조각들
    ↓ LLM (GPT-4o mini)
나만의 노트 기반 답변
```

## 근거 / 출처

- [[(240918)첫번째 RAG 기초 튜토리얼]] — 6단계 파이프라인 학습
- [[(260320)RAG란 무엇인가 검색 증강 생성 설명]] — Garbage in, Garbage out
- [[(241008)지식그래프로 RAG 성능 향상]] — 하이브리드 검색 가능성

## 반론 / 한계

- 한국어 임베딩 모델 선택 문제 — OpenAI vs 무료 모델
- 노트 품질이 낮으면 답변 품질도 낮다
- 지속적으로 노트가 추가되면 재임베딩 필요

## 연결 노트

- [[(260325)학습 일지]]
- [[(241016)대용량 문서용 RAG 시스템 파일 디렉토리]]

---

> 이 노트는 Claude Code로 작성되었습니다. 무단 배포를 금지합니다.
