---
type: doc
status: approved
tags: [policy, workflow]
---

# Obsidian 노트 작성 워크플로우

## 환경 정보

| 항목 | 경로/내용 |
|------|---------|
| Obsidian Vault | `C:\Dev\Obsidian` |
| Quartz | `C:\Dev\quartz` |
| Quartz content | `C:\Dev\quartz\content` |
| 배포 | GitHub → Netlify (kds-brain.netlify.app) |

---

## 폴더 구조

```
C:\Dev\Obsidian
├── 1. Areas
│   ├── Deep-Learning        ← 딥러닝 학습 노트 (Git 제외)
│   ├── DX                   ← DX 관련 노트
│   └── Python               ← Python 학습 노트
├── 2. Resources
│   ├── AI-Hardware
│   │   └── NPU              ← AI 하드웨어 개념 정리
│   ├── AI-News              ← 날짜별 AI 뉴스 (Netlify 배포)
│   ├── LLM
│   │   ├── Agent            ← AI 에이전트 아티클
│   │   └── RAG              ← RAG 아티클
│   ├── Articles
│   ├── Books
│   └── Papers
├── 3. Archive
├── 4. Zettelkasten          ← 아이디어 / 영구 노트
├── 5. Templates             ← 템플릿 파일 모음
├── 6. Attachments           ← 이미지, SVG 등 첨부 파일
└── Daily                    ← 학습 일지 ((YYMMDD)학습 일지.md)
```

---

## 파일명 규칙

모든 노트는 `(YYMMDD)제목` 형식으로 작성한다.

```
(260325)LangGraph로 AI 에이전트 구축하기 단계별 가이드.md
(260325)학습 일지.md
```

- 날짜는 괄호로 감싸고 6자리 (YYMMDD)
- 하이픈(-) 없이 공백으로 단어 구분
- `date` 필드가 없으면 `created` 기준으로 날짜 결정
- 파일 탐색기에서 날짜 기준 자동 정렬됨

---

## 폴더별 용도

| 폴더 | 용도 | Netlify 배포 |
|------|------|------------|
| `1. Areas` | 지속적 학습/실무 영역 (로컬 전용) | ❌ |
| `2. Resources/LLM` | AI 에이전트·RAG 아티클 정리 | ❌ |
| `2. Resources/AI-Concepts` | AI 개념 정리 레퍼런스 | ✅ |
| `2. Resources/AI-News` | 날짜별 AI 뉴스 | ✅ |
| `2. Resources/Articles` | 아티클 정리 | ✅ |
| `3. Archive` | 완료·보관 노트 | ❌ |
| `4. Zettelkasten` | 아이디어·영구 노트 | ❌ |
| `5. Templates` | 템플릿 파일 | ❌ |
| `6. Attachments` | 이미지·SVG 첨부 파일 | ❌ |
| `Daily` | 학습 일지 | ❌ |

---

## 템플릿 목록 (`5. Templates`)

| 템플릿 파일 | 용도 | 사용 폴더 |
|-----------|------|---------|
| `article.md` | 아티클 정리 | `2. Resources/LLM/`, `2. Resources/Articles` |
| `daily-log.md` | 학습 일지 | `Daily` |
| `idea.md` | 아이디어·영구 노트 | `4. Zettelkasten` |
| `dl-note.md` | 딥러닝 개념 노트 | `1. Areas/Deep-Learning` |
| `dx-note.md` | DX 노트 | `1. Areas/DX` |
| `python-note.md` | Python 노트 | `1. Areas/Python` |
| `book.md` | 책 정리 | `2. Resources/Books` |
| `paper.md` | 논문 정리 | `2. Resources/Papers` |
| `news.md` | 뉴스 정리 | `2. Resources/AI-News` |

---

## 노트 구조 규칙

### article 노트 구조

frontmatter 필드: `type` · `title` · `author` · `url` · `source` · `date` · `created` · `date_read` · `tags`

본문 순서:
```
# 제목
> 저자 / 출처

## 요약          ← 한 문장 핵심
## 핵심 포인트   ← 3개, 계층형 불릿 (메인 + 들여쓰기 세부)
## 인사이트      ← 읽고 나서 내 생각·의문·적용점
---
## (본문 내용 섹션들)
## 관련 노트
```

### 학습 일지 구조 (`Daily`)

```
## 오늘 읽은 것
### 주제별 분류
- [[노트 링크]]
    - 한 줄 요약

## 오늘의 인사이트
1. **핵심 명제**
    1. 세부 설명
2. ...
3. ...
```

### 아이디어 노트 구조 (`4. Zettelkasten`)

```
## 아이디어      ← 발상과 구현 방향
## 근거 / 출처   ← 연결된 아티클 링크
## 반론 / 한계   ← 현실적 제약
## 연결 노트
```

---

## 노트 작성 워크플로우

### Step 1. 폴더 및 템플릿 결정

| 작성 유형 | 폴더 | 템플릿 |
|----------|------|--------|
| AI 아티클 읽기 | `2. Resources/LLM/Agent` 또는 `RAG` | `article.md` |
| 오늘 학습 정리 | `Daily` | `daily-log.md` |
| 아이디어 기록 | `4. Zettelkasten` | `idea.md` |
| 딥러닝 학습 | `1. Areas/Deep-Learning` | `dl-note.md` |
| 뉴스 정리 | `2. Resources/AI-News` | `news.md` |

### Step 2. 템플릿 확인

```powershell
Get-Content "C:\Dev\Obsidian\5. Templates\[템플릿명].md" -Encoding UTF8
```

### Step 3. 파일 생성

파일명 형식: `(YYMMDD)제목.md`

```powershell
New-Item "C:\Dev\Obsidian\[폴더경로]\(YYMMDD)제목.md" -ItemType File
```

### Step 4. 내용 작성

```powershell
$content = @' ... '@
Set-Content -Path "C:\Dev\Obsidian\[폴더경로]\[파일명].md" -Value $content -Encoding UTF8
```

> ⚠️ 주의: `~` 기호는 Quartz에서 취소선으로 해석됨 → `\~` 로 이스케이프 필요

---

## Quartz 복사 → GitHub Push 워크플로우

### Netlify 배포가 필요한 노트만 아래 절차 진행

### Step 1. Quartz content 폴더 구조 생성 (최초 1회)

```powershell
New-Item -ItemType Directory -Force "C:\Dev\quartz\content\[Obsidian과 동일한 경로]"
```

### Step 2. Obsidian → Quartz 복사

```powershell
Copy-Item "C:\Dev\Obsidian\[폴더경로]\[파일명].md" "C:\Dev\quartz\content\[동일 경로]\[파일명].md"
```

### Step 3. Git Push

```powershell
cd C:\Dev\quartz && git add . && git commit -m "[커밋 메시지]" && git push origin main
```

### Step 4. Netlify 자동 배포 확인

- https://app.netlify.com → kds-brain → Deploys 탭 확인
- `Published` 상태 확인

---

## 주의사항

- Quartz의 content 폴더 구조는 **Obsidian 폴더 구조와 동일**하게 유지
- `1. Areas` 폴더 내 파일은 **Git Push 하지 않음** (로컬 전용)
- `Daily` 폴더 내 파일은 **Git Push 하지 않음** (개인 학습 기록)
- `4. Zettelkasten` 폴더 내 파일은 **Git Push 하지 않음** (아이디어 초안)
- Netlify 빌드 실패 시 → Deploys 탭에서 로그 확인
- `~` 기호 포함 파일은 반드시 `\~` 이스케이프 처리 후 Push
- `2. Resources` 폴더는 현재 `3. Resources`로 저장되어 있음 (Obsidian 종료 후 수동 변경 필요)
