library(htmltools)
Tags <- tags[names(tags) %in% c("div", "body", "span", "a",
                                "tr", "th", "td", "thead", "tbody", "p",
                                "select", "option", "input", "link", "nav",
                                "ul", "ol", "li", "label", "button", "script",
                                "section", "article", "em", "dl", "dt", "dd", "dfn")]
html <- function(...) tags$html(lang="en", ...)
library(purrr)
walk2(names(Tags), Tags, ~ assign(.x, .y, envir = globalenv()))
library(magrittr)
html0 <- function(...) HTML(paste0(...))
p0 <- function(..., as.html = FALSE, class = "")
  p(if(as.html) html0(...) else paste0(...), class = if(class != "") class)
disclaimer <- function(...) p0(class = "disclaimer", ...)
overlay <- function(id, ..., button.class = "")
{
  tagList(
    button(
      class = paste("overlay-toggler theme-bg theme-border", button.class),
      "?", `data-target` = id
    ),
    div(class = "overlay hidden", id = id, p0(...))
  )
}
overlay.img <- function(id, src, alt1, alt2)
{
  tagList(
    img(src = src, class = "overlay-toggler", `data-target` = id, alt = alt1),
    div(class = "overlay hidden", id = id, img(src = src, alt = alt2))
  )
}

write2file <- function(x, file)
{
  cat('<!DOCTYPE html>',
      gsub("<(/?)header>", "<\\1head>", gsub("^  ", "", capture.output(x))),
      file = file, append = FALSE, sep = "\n")
}

HTMLhead <- function(titl, js = "blank", desc = "", home = "../", date)
{
  tags$header(
    HTML("<!-- Global site tag (gtag.js) - Google Analytics -->"),
    tags$script(async=NA, src="https://www.googletagmanager.com/gtag/js?id=UA-130554917-1"),
    tags$script(
      "window.dataLayer = window.dataLayer || [];",
      "function gtag(){dataLayer.push(arguments);}",
      "gtag('js', new Date());",
      "gtag('config', 'UA-130554917-1');"
    ),
    tags$title(paste0("Adulting: ", titl)),
    tags$meta(name="description", content=desc),
    tags$meta(name="author", content="E Heinzen"),
    tags$meta(name="date", content=date),
    tags$meta(name="viewport", content="width=device-width, initial-scale=1"),
    link(rel="stylesheet", href=paste0(home, "styles.css")),
    map(c(js, "init"), ~ script(src = paste0(home, "js/", .x, ".js")))
  )
}

navbar <- function(home = "../")
{
  tagList(
    h1(a("Adulting", href = paste0(home, "index.html"))),
    nav(
      ul(
        class = "row",
        li(
          class = "left finance theme-bg theme-border",
          a(href = paste0(home, "finance/index.html"), "Finance")
        ),
        li(
          class = "left faith theme-bg theme-border",
          a(href = paste0(home, "faith/index.html"), "Faith")
        ),
        li(
          class = "left fun theme-bg theme-border",
          a(href = paste0(home, "fun/index.html"), "Fun")
        ),
        li(
          class = "left outdoors theme-bg theme-border",
          a(href = paste0(home, "outdoors/index.html"), "Outdoors")
        ),
        li(
          class = "left home theme-bg theme-border",
          a(href = paste0(home, "about.html"), "About")
        )
      )
    )
  )
}

foot <- function(...)
{
  # if you change this, also edit parse_md.R
  tags$footer(
    p0("References and Other Useful Links:"),
    do.call(ul, lapply(list(...), li))
  )
}

source("R/parse_md.R")
list.files("md/", "\\.md$", full.names = TRUE) %>%
  walk(~ parse_md(print(.x)))

list.files("R/", "\\.R$", full.names = TRUE) %>%
  "["(. != "R/helpers.R") %>%
  "["(order(. == "R/index.R")) %>%
  walk(~ source(print(.x)))
