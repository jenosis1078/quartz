---
type: hub
tags: [hub]
---

# 🏠 Home

## 📋 진행 중인 프로젝트
```dataview
table status, due
from "1. Projects"
where type = "project" and status = "in-progress"
sort due asc
```

## 📰 최근 AI 뉴스
```dataview
table date
from "3. Resources/AI-News"
sort date desc
limit 5
```

## 🔬 최근 논문
```dataview
table authors, year
from "3. Resources/Papers"
sort file.mtime desc
limit 5
```

## 💡 최근 아이디어
```dataview
table file.mtime as "작성일"
from "5. Zettelkasten"
sort file.mtime desc
limit 5
```
