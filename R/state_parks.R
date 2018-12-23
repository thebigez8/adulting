
# make_sp_page <- function(i, dat)
# {
#   html
# }

state.parks <- "rawdata/state_parks.csv" %>%
  read.csv(header = TRUE, stringsAsFactors = FALSE) %>%
  dplyr::arrange(-as.numeric(as.Date(date)))
park_row <- function(name, ID, date, hc.len, len, summer, hc.rating, rating, experience)
{
  home <- paste0("https://www.dnr.state.mn.us/state_parks/park.html?id=", ID, "#homepage")
  trails <- sub("#homepage", "#trails", home, fixed = TRUE)
  if(summer == "Y") summer <- "_summer"
  mappdf <- paste0("https://files.dnr.state.mn.us/maps/state_parks/", ID, summer, ".pdf")
  tr(
    th(a(name, href = home)),
    td(date),
    td(a("Map", href = mappdf)),
    td(a(paste0(hc.len, " (", len, ")"), href = trails)),
    td(a(paste0(hc.rating, " (", rating, ")"), href = "#"))
  )
}

html(
  class = "outdoors theme-bg",
  HTMLhead(
    titl = "MN State Parks", home = "../../",
    keywords = "Hiking,MN,Hiking Club,Hiking Trails,Minnesota,State Parks",
    desc = "Information about and reviews of MN State Parks",
    date = "2018-10-25"
  ),
  body(
    navbar(home = "../../"),
    h2("Minnesota State Parks"),
    p0(
      as.html = TRUE,
      "Minnesota is a beautiful state with 67 state parks to enjoy. You can find all the state ",
      "parks on ", a("their website", href = "https://www.dnr.state.mn.us/state_parks/map.html"),
      ", which also includes ",
      a("virtual tours", href = "https://www.dnr.state.mn.us/state_parks/virtual_tours.html"),
      "."
    ),
    p("Here's a list of all the state parks whose hiking club trail I've completed:"),
    div(
      class = "scroller-x",
      tags$table(
        class = "bordered",
        thead(
          th("Park"), th("Date Visited"), th("Map"),
          th("Hiking Club Length", tags$br(), "(Total Trails)"),
          th("Hiking Club Trail Rating", tags$br(), "(Total Rating)")
        ),
        tbody(
          pmap(state.parks, park_row),
          tr(td(colspan = 3), td(sum(state.parks$hc.len)), td())
        )
      )
    )
  )
) %>%
  write2file(file = "docs/outdoors/MN_state_parks/index.html")

spk.repo <- "https://raw.githubusercontent.com/thebigez8/state_parks/master/"
tourcsv <- paste0(spk.repo, "optimal_map.csv")
html(
  class = "outdoors theme-bg",
  HTMLhead(
    titl = "MN State Parks Tour", home = "../../", js = c("overlay", "overlay_only"),
    keywords = "MN,Minnesota,State Parks,three opt,travelling salesman",
    desc = "Efficient Tours of MN State Parks",
    date = "2018-11-19"
  ),
  body(
    navbar(home = "../../"),
    h2("Minnesota State Parks and Recreation Areas Tour"),
    p0(
      "Using a ", a("three-opt algorithm", href = paste0(spk.repo, "three_opt.cpp")),
      ", we found the following proposed shortest tour of all the MN state parks and ",
      "recreation areas. The route is about 2850 miles long.", as.html = TRUE
    ),
    overlay.img(
      id = "larger-image",
      src = paste0(spk.repo, "MN_state_parks_route.png"),
      alt1 = "State Park Route Map", alt2 = "Larger State Park Route Map"
    ),
    p0(
      "Constructing a tour like this turns out to be a hard problem known as the ",
      '"Travelling Salesman" problem. While there are ',
      a("algorithms", href = "http://www.math.uwaterloo.ca/tsp/index.html"),
      " that can find the guaranteed shortest route, they get complicated, and ",
      "complicated is no fun to program. Here, we'll try out the three-opt algorithm.",
      as.html = TRUE
    ),
    p0(
      "In short, the ", dfn("three-opt algorithm"),
      " starts with a random tour of the parks and at each step ",
      "considers three pairs of connected parks. If a rearrangement of the connections ",
      "gives a shorter tour, the algorithm picks the shortest such rearrangement. ",
      "This continues until no better rearrangement is found. It is important to run the ",
      "algorithm many times to ensure that it picks the ", em("best"), " route instead of ",
      "just a good one. Nevertheless, three-opt remains a heuristic, so the route presented here ",
      "still may not be the ", em("best"), ". All we do is propose that it's ",
      a("pretty good", href = "https://twitter.com/MathIsEH/status/1062203770816344064"),
      ".", as.html = TRUE
    ),
    p0(
      "For reference, here are the parks in order of the route (also ",
      a("in a CSV", href = tourcsv), "):", as.html = TRUE
    ),
    ul(
      map(sub(" MN", "", readLines(tourcsv)), li)
    )
  )
) %>%
  write2file(file = "docs/outdoors/MN_state_parks/MN_state_park_tour.html")
