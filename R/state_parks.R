
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
  HTMLhead(
    titl = "MN State Parks", home = "../../",
    keywords = "Hiking,MN,Hiking Club,Hiking Trails,Minnesota,State Parks",
    desc = "Information about and reviews of MN State Parks",
    date = "2018-10-08"
  ),
  body(
    class = "outdoors",
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
) %>%
  write2file(file = "docs/outdoors/MN_state_parks/index.html")


