make_article <- function(URL)
{
  pg <- xml2::read_html(URL)
  met <- rvest::html_nodes(pg, "meta, title")
  titl <- gsub("^Adulting: ", "", rvest::html_text(met[[1]]))
  clss <- rvest::html_attr(pg, "class", default = "")
  date <- rvest::html_attrs(met)[[5]]["content"]
  list(
    article(
      class = paste0("toggleable bordered ", clss),
      h3(a(titl, href = sub("docs/", "", URL))),
      p(rvest::html_attrs(met)[[3]]["content"]),
      div(class = "left text-left", date),
      div(class = "right text-right")
    ),
    date = date
  )
}

pgs <- list.files("docs", full.names = TRUE, "\\.html", recursive = TRUE) %>%
  "["(. != "docs/index.html") %>%
  map(make_article) %>%
  "["(order(map_chr(., "date"), decreasing = TRUE)) %>%
  map(1)

html(
  class = "home",
  HTMLhead(
    titl = "Home", "js/index.js", toggle = TRUE, home = "",
    keywords = "Finance,Fun,Faith,Outdoors",
    desc = "Adulting Home Page",
    date = "2018-10-08"
  ),
  body(
    navbar(home = ""),
    section(
      class = "tag-filters",
      h2("New pages:"),
      span("Filter:"),
      button("Finance", type = "button", class = "finance toggler", `data-target` = "finance"),
      button("Faith", type = "button", class = "faith toggler", `data-target` = "faith"),
      button("Fun", type = "button", class = "fun toggler", `data-target` = "fun"),
      button("Outdoors", type = "button", class = "outdoors toggler", `data-target` = "outdoors"),
      pgs
    )
  )
) %>%
  write2file(file = "docs/index.html")


