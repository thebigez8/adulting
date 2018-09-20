make_article <- function(txt, desc, URL = "#", type = c("finance", "faith", "fun", "outdoors"))
{
  article(
    class = paste0("toggleable bordered ", match.arg(type)),
    h3(a(txt, href = URL)),
    p(desc),
    div()
  )
}
html(
  HTMLhead(titl = "Home", script(src = "js/index.js"), toggle = TRUE),
  body(
    navbar(),
    section(
      class = "tag-filters",
      h2("New pages:"),
      span("Filter:"),
      button("Finance", type = "button", id = "finance-toggle", class = "finance toggler"),
      button("Faith", type = "button", id = "faith-toggle", class = "faith toggler"),
      button("Fun", type = "button", id = "fun-toggle", class = "fun toggler"),
      button("Outdoors", type = "button", id = "outdoors-toggle", class = "outdoors toggler"),
      make_article(
        "Roth vs. Traditional Retirement Account Calculator",
        paste0(
          "A calculator to determine whether a Roth or traditional retirement account ",
          "makes more sense, given tax rates, rates of returns, etc."
        ), "roth_vs_trad.html", "finance"
      ),
      make_article("An article about faith", "Test", "#", "faith"),
      make_article("An article about fun", "Another test", "#", "fun"),
      make_article("An article about outdoorsy stuff", "Hiking rulez", "#", "outdoors")
    )
  )
) %>%
  write2file(file = "docs/index.html")


