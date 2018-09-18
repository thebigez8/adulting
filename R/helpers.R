library(htmltools)
Tags <- tags[names(tags) %in% c("div", "html", "body", "span", "a",
                                "tr", "th", "td", "thead", "tbody", "p",
                                "select", "option", "input", "link", "nav",
                                "ul", "li", "label", "button", "script",
                                "section", "article")]
purrr::walk2(names(Tags), Tags, ~ assign(.x, .y, envir = globalenv()))
library(magrittr)
p0 <- function(...) p(paste0(...))

write2file <- function(x, file)
{
  cat("<!DOCTYPE html>",
      gsub("^  ", "", capture.output(x)),
      file = file, append = FALSE, sep = "\n")
}

HTMLhead <- function(titl, js = NULL)
{
  HTML(paste0(
    "<head>\n    ",
    tags$title(paste0("Adulting: ", titl)), "\n    ",
    link(rel="stylesheet", href="styles.css"), "\n    ",
    js,
    "\n</head>"
  ))
}

navbar <- function()
{
  tagList(
    h1(a("Adulting", href = "index.html")),
    nav(
      ul(
        li(a(href = "#", "[This link coming soon]")),
        li(a(href = "#", "[This link coming soon]"))
      )
    )
  )
}

source("R/index.R")
source("R/roth_vs_trad.R")
source("R/medical_plans.R")
