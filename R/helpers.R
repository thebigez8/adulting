library(htmltools)
Tags <- tags[names(tags) %in% c("div", "html", "body", "span", "a",
                                "tr", "th", "td", "thead", "tbody", "p",
                                "select", "option", "input", "link", "nav",
                                "ul", "li", "label", "button", "script",
                                "section", "article")]
library(purrr)
walk2(names(Tags), Tags, ~ assign(.x, .y, envir = globalenv()))
library(magrittr)
p0 <- function(..., as.html = FALSE, class = "")
  p(if(as.html) HTML(paste0(...)) else paste0(...), class = if(class != "") class)
disclaimer <- function(...) p0(class = "disclaimer", ...)

write2file <- function(x, file)
{
  cat("<!DOCTYPE html>",
      gsub("^  ", "", capture.output(x)),
      file = file, append = FALSE, sep = "\n")
}

HTMLhead <- function(titl, js = paste0(home, "js/blank.js"), toggle = FALSE,
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
    if(toggle) script(src = paste0(home, "js/toggle.js")),
    script(src = js),
    script(src = paste0(home, "js/init.js")),
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
