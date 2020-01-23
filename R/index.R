generate_article <- function(URL, prefix)
{
  pg <- xml2::read_html(paste0(prefix, URL))
  titl <- pg %>%
    rvest::html_nodes("title") %>%
    rvest::html_text() %>%
    gsub(pattern = "^Adulting: ", replacement = "")
  met <- pg %>%
    rvest::html_nodes("meta") %>%
    rvest::html_attrs() %>%
    "["(map_lgl(., ~ "name" %in% names(.x))) %>%
    map(~ set_names(.x["content"], .x["name"])) %>%
    unlist()
  clss <- strsplit(rvest::html_attr(pg, "class", default = ""), " ")[[1]][1]
  make_article(met["date"], clss, titl, URL, met["description"])
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
    dplyr::filter(class == clss | clss == "") %>%
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
    desc = "Adulting Home Page",
    date = "2018-10-08"
  ),
  body(
    navbar(home = ""),
    section(
      class = "tag-filters",
      h2("New pages:"),
      div(
        class="hidden",
        span("Filter by tag:"),
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
        )
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
