make_article <- function(URL)
{
  met <- URL %>%
    xml2::read_html() %>%
    rvest::html_nodes("meta, title")
  titl <- gsub("^Adulting: ", "", rvest::html_text(met[[1]]))
  article(
    class = paste0("toggleable bordered ", sub("^.*/(.*)/.*\\.html$", "\\1", URL)),
    h3(a(titl, href = sub("docs/", "", URL))),
    p(rvest::html_attrs(met)[[3]]["content"]),
    div()
  )
}

pgs <- list.files("docs", full.names = TRUE, "\\.html", recursive = TRUE) %>%
  "["(. != "docs/index.html")

html(
  HTMLhead(
    titl = "Home", script(src = "js/index.js"), toggle = TRUE,
    keywords = "Finance,Fun,Faith,Outdoors",
    desc = "Adulting Home Page"
  ),
  body(
    navbar(updir = FALSE),
    section(
      class = "tag-filters",
      h2("New pages:"),
      span("Filter:"),
      button("Finance", type = "button", id = "finance-toggle", class = "finance toggler"),
      button("Faith", type = "button", id = "faith-toggle", class = "faith toggler"),
      button("Fun", type = "button", id = "fun-toggle", class = "fun toggler"),
      button("Outdoors", type = "button", id = "outdoors-toggle", class = "outdoors toggler"),
      purrr::map(pgs, make_article)
    )
  )
) %>%
  write2file(file = "docs/index.html")


