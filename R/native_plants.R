
TYPES <- c("deciduous shrub & small tree", "deciduous tree", "evergreen conifer", "fern",
           "flower & groundcover", "grass & sedge", "vine")

"https://raw.githubusercontent.com/thebigez8/native_plants/master/html/native_plants.json" %>%
  readLines() %>%
  paste0(c("var plants = ", rep("", times = length(.) - 1)), ., c(rep("", times = length(.) - 1), ";")) %>%
  c(paste0("var plant_types = [", paste0('"', TYPES, '"', collapse = ", "), "];\n"), .) %>%
  writeLines("docs/js/native_plants_data.js")

tab <- "https://raw.githubusercontent.com/thebigez8/native_plants/master/html/native_plants.html" %>%
  xml2::read_html() %>%
  rvest::html_node("table") %>%
  as.character() %>%
  gsub(pattern = "\r", replacement = "") %>%
  gsub(pattern = "><", replacement = ">\n<", fixed = TRUE) %>%
  HTML()

html(
  class = "outdoors theme-bg",
  HTMLhead(
    titl = "MN Native Plants", js = c("native_plants_data", "native_plants"), css = "native_plants",
    desc = "A searchable list of MN-native plants",
    date = "2020-01-17"
  ),
  body(
    navbar(),
    h2("Minnesota Native Plants"),
    div(
      class="row",
      div(
        class="col width-3 inputs-panel bordered",
        h3("Filter"),
        label(`for`="type", "Type of Plant", class="plantlabel"),
        map(1:7, ~ label(input(type="checkbox", id=paste0("type-", .x), name="type", checked=NA), TYPES[.x])),
        label(`for`="zone", "Zone", class="plantlabel"),
        map(1:4, ~ label(input(type="checkbox", id=paste0("zone-", .x), name="zone", checked=NA), paste("Zone", .x))),
        label("Region of MN", class = "mn plantlabel"),
        map(0:2, function(r) {
          div(
            class = "row mn",
            map(3*r + (1:3), function(i) {
              div(
                class = "mn-region left width-4",
                input(type="checkbox", id=paste0("mn-", i), checked=NA),
                label(`for`=paste0("mn-", i), class="text-center", c("NW", "NC", "NE", "WC", "C", "EC", "SW", "SC", "SE")[i])
              )
            })
          )
        }),
        div(
          class = "mn mn-region",
          input(type="checkbox", id="mn-unk", checked=NA),
          label(`for`="mn-unk", class="text-center", "?")
        ),
        div(
          class = "row plantlabel",
          div(class = "left text-left width-6", "Sunny"),
          div(class = "left text-right width-5", "Shady")
        ),
        div(
          class = "row scale",
          map(c(10:0, list("unk")), function(i) {
            div(
              class = "left width-1",
              input(type="checkbox", id=paste0("sun-", i), checked=NA),
              label(`for`=paste0("sun-", i), class=paste0("text-center rdbu", if(i != "unk") 10-i else "-unk"),
                    if(i == "unk") "?")
            )
          })
        ),
        div(
          class = "row plantlabel",
          div(class = "left text-left width-3", "Dry"),
          div(class = "left text-right width-3", "Submerged")
        ),
        div(
          class = "row scale",
          map(c(0:5, list("unk")), function(i) {
            div(
              class = "left width-1",
              input(type="checkbox", id=paste0("moisture-", i), checked=NA),
              label(`for`=paste0("moisture-", i), class=paste0("text-center rdbu", if(i != "unk") 2*i else "-unk"),
                    if(i == "unk") "?")
            )
          })
        ),
        div(
          class = "row plantlabel",
          div(class = "left text-left width-3", "Acidic"),
          div(class = "left text-right width-4", "Alkaline")
        ),
        div(
          class = "row scale",
          map(c(0:6, list("unk")), function(i) {
            div(
              class = "left width-1",
              input(type="checkbox", id=paste0("ph-", i), checked=NA),
              label(`for`=paste0("ph-", i), class=paste0("text-center rdbu", if(i != "unk") round(i*5/3) else "-unk"),
                    if(i == "unk") "?")
            )
          })
        ),
        div(
          class = "row",
          label(`for`="feature", "Notable Feature", class="plantlabel"),
          select(
            id="feature",
            option(value="no filter", "no filter"),
            option(value="prairie", "native to prairie"),
            option(value="deciduous_forest", "native to deciduous forest"),
            option(value="coniferous_forest", "native to coniferous forest"),
            option(value="butterfly_nectar", "good for butterfly nectar"),
            option(value="butterfly_larval", "good for butterfly larvae"),
            option(value="hummingbirds", "good for hummingbirds"),
            option(value="moist_soil", "good for moist soil"),
            option(value="pond", "good for ponds"),
            option(value="shallow_water", "good for shallow water"),
            option(value="rock_sunny", "good for rocks (sunny)"),
            option(value="rock_shady", "good for rocks (shady)"),
            option(value="groundcover", "good for groundcover"),
            option(value="deer_resistant", "good for deer resistance"),
            option(value="shade_garden", "good for shade gardens"),
            option(value="mixed_border", "good for mixed borders"),
            option(value="front_yard_sunny", "good for front yards (sunny)"),
            option(value="front_yard_shady", "good for front yards (shady)"),
            option(value="front_yard_woody", "good for front yards (woody)")
          )
        )
      ),
      div(
        class = "col width-9 outputs-panel",
        p0(
          "Below is a list of native plants with which to landscape, based on a book by Lynn M. Steiner (see below). ",
          "Plants which are native to MN but not appropriate for landscaping are ignored (in particular, the American ",
          "Elm and the Dwarf Trout Lily)."
        ),
        div(class="scroller-x", id="native-plants-table", tab),
        p("Sorry, no plants match those criteria.", id="nomatch")
      )
    ),
    foot(
      html0("<i>Landscaping with Native Plants of Minnesota (2nd edition)</i> by Lynn M. Steiner")
    )
  )
) %>%
  write2file(file = "docs/outdoors/native_plants.html")

# I'm picky about my formatting
"docs/outdoors/native_plants.html" %>%
  readLines() %>%
  gsub(pattern = "^([^<]*</?(thead|th|td|tbody|tr|i>).*)", replacement = "        \\1") %>%
  gsub(pattern = "^([^<]*</?(tr|td|th>|i>).*)", replacement = "  \\1") %>%
  gsub(pattern = "^([^<]*</?(td|th>|i>).*)", replacement = "  \\1") %>%
  gsub(pattern = "^([^<]*</table>.*)", replacement = "      \\1") %>%
  sub(pattern = "<tbody>", replacement = '<tbody id="plant-tbody">') %>%
  writeLines("docs/outdoors/native_plants.html")
