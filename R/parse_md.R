
library(stringr)
parse_md <- function(fn, prefix = "    ")
{
  # I don't want to use includeMarkdown because it doesn't format as pretty,
  # nor does it do the footnotes like how I want.
  group_li <- function(x, w)
  {
    i <- grepl("^\\s*<li", x)
    idx <- c(i, FALSE) & !c(FALSE, i)
    tapply(x, cumsum(!i | idx[-length(idx)]), paste0, collapse = "\n") %>%
      str_replace("^(\\s*<li(.|\n)*)", paste0("<", w, "l>\n\\1\n</", w, "l>"))
  }
  code <- fn %>%
    readLines() %>%
    trimws()

  dashes <- which(code == "---")
  yam <- code %>%
    head(dashes[2]) %>%
    "["(. != "---") %>%
    gsub(pattern = '"', replacement = "") %>%
    str_split(": ", n = 2) %>%
    lapply(function(x) set_names(x[2], x[1])) %>%
    unlist()

  pg <- code %>%
    tail(-dashes[2]) %>%
    tapply(cumsum(. == ""), paste0, collapse = " ") %>%
    trimws() %>%
    setdiff("") %>%

    # do the elements which don't belong in paragraphs
    str_replace("^## (.*)", "<h2>\\1</h2>") %>%
    str_replace("^### (.*)", "<h3>\\1</h3>") %>%
    str_replace("^#### (.*)", "<h4>\\1</h4>") %>%
    str_replace(
      "^\\[(\\d+)\\] (.*)",
      '  <li id="footnote-\\1"><a href="#ref-\\1" class="reference-link">^</a> \\2</li>'
    ) %>%
    group_li("o") %>%
    str_replace("^- (.*)", "  <li>\\1</li>") %>%
    group_li("u") %>%

    # replace with paragraphs and do all the inline stuff
    str_replace("^(\\s*[^<\\s].*)", "<p>\\1</p>") %>%
    str_replace_all(
      "\\[(\\d+)\\]",
      '<sup><a href="#footnote-\\1" id="ref-\\1" class="reference-link">\\1</a></sup>'
    ) %>%
    str_replace_all("\\[(.*?)\\]\\((.*?)\\)", '<a href="\\2">\\1</a>') %>%
    str_replace_all("\\*(.*?)\\*", "<em>\\1</em>") %>%
    str_replace_all("\\\\\\\\<", "<") %>%
    paste0(collapse = "\n") %>%
    str_replace(
      "<p>---Footnotes---</p>\n(<ol>(\n|.)+</ol>)",
      "<footer>\n\\1\n</footer>"
    ) %>%
    str_split("\n") %>%
    "[["(1) %>%
    paste0(prefix, ., collapse = "\n") %>%
    trimws() %>%
    HTML()

  html(
    class = yam["class"],
    HTMLhead(
      titl = yam["title"], js = "blank",
      desc = yam["desc"],
      date = yam["date"]
    ),
    body(
      navbar(),
      pg
    )
  ) %>%
    write2file(file = yam["url"])
}
