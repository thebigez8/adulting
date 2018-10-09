make_article <- function(URL)
{
  pg <- xml2::read_html(URL)
  met <- rvest::html_nodes(pg, "meta, title")
  titl <- gsub("^Adulting: ", "", rvest::html_text(met[[1]]))
  clss <- pg %>%
    rvest::html_nodes("body") %>%
    rvest::html_attr("class", default = "")
  date <- rvest::html_attrs(met)[[5]]["content"]
  list(
    article(
      class = paste0("toggleable bordered ", clss),
      h3(a(titl, href = sub("docs/", "", URL))),
      p(rvest::html_attrs(met)[[3]]["content"]),
      div(class = "left", date),
      div(class = "right")
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
      button("Finance", type = "button", id = "finance-toggle", class = "finance toggler"),
      button("Faith", type = "button", id = "faith-toggle", class = "faith toggler"),
      button("Fun", type = "button", id = "fun-toggle", class = "fun toggler"),
      button("Outdoors", type = "button", id = "outdoors-toggle", class = "outdoors toggler"),
      pgs
    )
  )
) %>%
  write2file(file = "docs/index.html")


