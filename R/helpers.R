library(htmltools)
Tags <- tags[names(tags) %in% c("div", "html", "body", "span", "a",
                                "tr", "th", "td", "thead", "tbody", "p",
                                "select", "option", "input", "link", "nav",
                                "ul", "li", "label", "button", "script",
                                "section", "article", "em", "dl", "dt", "dd", "dfn")]
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
    button(class = paste("overlay-toggler", button.class), "?", `data-target` = id),
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
  cat("<!DOCTYPE html>",
      gsub("^  ", "", capture.output(x)),
      file = file, append = FALSE, sep = "\n")
}

HTMLhead <- function(titl, js = "blank",
                     keywords = "", desc = "", home = "../", date)
{
  HTML(paste0(paste(
    "<head>",
    tags$title(paste0("Adulting: ", titl)),
    tags$meta(name="keywords", content=paste0("adulting,", keywords)),
    tags$meta(name="description", content=desc),
    tags$meta(name="author", content="E Heinzen"),
    tags$meta(name="date", content=date),
    tags$meta(name="viewport", content="width=device-width, initial-scale=1"),
    link(rel="stylesheet", href=paste0(home, "styles.css")),
    paste0(map_chr(c(js, "init"), ~ paste(script(src = paste0(home, "js/", .x, ".js")))), collapse = "\n    "),
    sep = "\n    "
  ), "\n</head>"))
}

navbar <- function(home = "../")
{
  tagList(
    h1(a("Adulting", href = paste0(home, "index.html"))),
    nav(
      ul(
        li(a(href = "#", "[This link coming soon]")),
        li(a(href = "#", "[This link coming soon]"))
      )
    )
  )
}

source("R/roth_vs_trad.R")
source("R/medical_plans.R")
source("R/pizza_calculator.R")
source("R/state_parks.R")
source("R/index.R")
