---
type: hub
tags:
  - hub
publish: true
---
# 🏠 Home

## 📖 최근 학습 일지
```dataview
table date
from "Daily"
where type = "daily-log"
sort date desc
limit 5
```

## 📰 최근 AI 뉴스
```dataview
table date
from "2. Resources/AI-News"
sort date desc
limit 5
```

## 🔬 최근 논문
```dataview
table authors, year
from "2. Resources/Papers"
sort file.mtime desc
limit 5
```

## 💡 최근 아이디어
```dataview
table file.mtime as "작성일"
from "4. Zettelkasten"
sort file.mtime desc
limit 5
```
