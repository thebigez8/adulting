
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
    div(
      class = "row",
      h2("About this site"),
      p0(
        "This site is a conglomerate of financial advice, musings on faith, fun links, and ",
        'outdoors blogging. It was originally designed to make "adulting" easier.'
      ),
      p0(
        "This site is entirely open source. To alert us to errors, bugs, or misinformation, ",
        "please file an issue on ",
        a("this site's GitHub page", href = "https://github.com/thebigez8/adulting"),
        ".", as.html = TRUE
      )
    )
  )
) %>%
  write2file(file = "docs/about.html")
