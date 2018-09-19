make_article <- function(txt, desc, URL = "#", type = c("finance", "faith", "fun", "outdoors"))
{
  article(
    class = paste0("bordered ", match.arg(type)),
    h3(a(txt, href = URL)),
    p(desc),
    div()
  )
}
html(
  HTMLhead(titl = "Home"),
  body(
    navbar(),
    section(
      class = "tag-filters",
      h2("New pages:"),
      span("Filter:"),
      input(type = "checkbox", id = "finance-tags"),
      label("Finance", `for` = "finance-tags", class = "finance"),
      input(type = "checkbox", id = "faith-tags"),
      label("Faith", `for` = "faith-tags", class = "faith"),
      input(type = "checkbox", id = "fun-tags"),
      label("Fun", `for` = "fun-tags", class = "fun"),
      input(type = "checkbox", id = "outdoors-tags"),
      label("Outdoors", `for` = "outdoors-tags", class = "outdoors"),
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


