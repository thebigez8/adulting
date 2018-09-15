
html(
  HTMLhead(titl = "Home"),
  body(
    navbar(),
    section(
      h2("New pages:"),
      article(
        h3(a("Roth vs. Traditional Retirement Account Calculator", href = "roth_vs_trad.html")),
        p0(
          "A calculator to determine whether a Roth or traditional retirement account ",
          "makes more sense, given tax rates, rates of returns, etc."
        )
      )
    )
  )
) %>%
  write2file(file = "docs/index.html")


