import { QuartzComponentConstructor, QuartzComponentProps } from "./types"
import style from "./styles/articleMeta.scss"

export default (() => {
  function ArticleMeta({ fileData }: QuartzComponentProps) {
    const fm = fileData.frontmatter
    if (!fm || fm.type !== "article") return null

    const rows: { label: string; value: JSX.Element | string | null }[] = [
      {
        label: "저자",
        value: fm.author ?? null,
      },
      {
        label: "URL",
        value: fm.url ? (
          <a href={fm.url as string} target="_blank" rel="noopener noreferrer">
            {(fm.url as string).replace(/^https?:\/\//, "").split("/")[0]}
          </a>
        ) : null,
      },
      {
        label: "출처",
        value: fm.source ?? null,
      },
      {
        label: "업로드",
        value: fm.date ? String(fm.date).slice(0, 10) : null,
      },
      {
        label: "작성",
        value: fm.created ? String(fm.created).slice(0, 10) : null,
      },
      {
        label: "읽은날",
        value: fm.date_read ? String(fm.date_read).slice(0, 10) : null,
      },
      {
        label: "태그",
        value:
          fm.tags && (fm.tags as string[]).length > 0 ? (
            <span class="article-meta-tags">
              {(fm.tags as string[]).map((tag) => (
                <span class="article-meta-tag">{tag}</span>
              ))}
            </span>
          ) : null,
      },
    ]

    const visibleRows = rows.filter((r) => r.value !== null && r.value !== undefined && r.value !== "")

    if (visibleRows.length === 0) return null

    return (
      <div class="article-meta">
        {visibleRows.map((row) => (
          <div class="article-meta-row">
            <span class="article-meta-label">{row.label}</span>
            <span class="article-meta-value">{row.value}</span>
          </div>
        ))}
      </div>
    )
  }

  ArticleMeta.css = style
  return ArticleMeta
}) satisfies QuartzComponentConstructor
