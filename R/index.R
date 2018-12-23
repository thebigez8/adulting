generate_article <- function(URL, prefix)
{
  pg <- xml2::read_html(paste0(prefix, URL))
  met <- rvest::html_nodes(pg, "meta, title")
  titl <- gsub("^Adulting: ", "", rvest::html_text(met[[1]]))
  clss <- strsplit(rvest::html_attr(pg, "class", default = ""), " ")[[1]][1]
  date <- rvest::html_attrs(met)[[5]]["content"]
  make_article(date, clss, titl, URL, rvest::html_attrs(met)[[3]]["content"])
}

make_article <- function(date, class, title, href, content)
{
  list(
    article(
      class = paste0("toggleable bordered ", class),
      h3(a(title, href = href)),
      p(content),
      div(class = "left text-left", date),
      div(class = "right text-right")
    ),
    date = date,
    class = class
  )
}

get_pgs <- function(clss)
{
  externals <- "rawdata/external_pages.csv" %>%
    read.csv(header = TRUE, stringsAsFactors = FALSE) %>%
    dplyr::mutate(content = paste("[EXTERNAL]", content)) %>%
    dplyr::filter(class == clss) %>%
    pmap(make_article)

  patt <- paste0("docs/", clss, if(clss != "") "/")
  list.files("docs", full.names = TRUE, "\\.html", recursive = TRUE) %>%
    "["(!grepl("^docs/([^/]+/)?(index|about)\\.html$", .)) %>%
    grep(pattern = patt, value = TRUE) %>%
    sub(pattern = patt, replacement = "") %>%
    map(generate_article, prefix = patt) %>%
    c(externals) %>%
    "["(order(map_chr(., "date"), decreasing = TRUE)) %>%
    map(1)
}

html(
  class = "home theme-bg",
  HTMLhead(
    titl = "Home", js = c("toggle", "index"), home = "",
    keywords = "Finance,Fun,Faith,Outdoors",
    desc = "Adulting Home Page",
    date = "2018-10-08"
  ),
  body(
    navbar(home = ""),
    section(
      class = "tag-filters",
      h2("New pages:"),
      span("Filter new pages by tag:"),
      button(
        "Finance", type = "button", `data-target` = "finance",
        class = "finance theme-bg theme-border toggler"
      ),
      button(
        "Faith", type = "button", `data-target` = "faith",
        class = "faith theme-bg theme-border toggler"
      ),
      button(
        "Fun", type = "button", `data-target` = "fun",
        class = "fun theme-bg theme-border toggler"
      ),
      button(
        "Outdoors", type = "button", `data-target` = "outdoors",
        class = "outdoors theme-bg theme-border toggler"
      ),
      get_pgs("")
    )
  )
) %>%
  write2file(file = "docs/index.html")

make_index <- function(clss)
{
  html(
    class = paste(tolower(clss), "theme-bg"),
    HTMLhead(
      titl = clss, js = "blank", home = "../",
      keywords = clss,
      desc = paste0("Adulting: ", clss),
      date = "2018-12-23"
    ),
    body(
      navbar(home = "../"),
      section(
        h2("New pages:"),
        get_pgs(tolower(clss))
      )
    )
  ) %>%
    write2file(file = paste0("docs/", tolower(clss), "/index.html"))
}

make_index("Finance")
make_index("Faith")
make_index("Fun")
make_index("Outdoors")
