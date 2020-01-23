
tab <- "https://raw.githubusercontent.com/thebigez8/native_plants/master/html/native_plants.html" %>%
  xml2::read_html() %>%
  rvest::html_node("table") %>%
  as.character() %>%
  gsub(pattern = "\r", replacement = "") %>%
  gsub(pattern = "><", replacement = ">\n<", fixed = TRUE) %>%
  HTML()

TYPES <- c("deciduous shrub & small tree", "deciduous tree", "evergreen conifer", "fern",
           "flower & groundcover", "grass & sedge", "vine")

html(
  class = "outdoors theme-bg",
  HTMLhead(
    titl = "MN Native Plants", js = "native_plants", css = "native_plants",
    desc = "A searchable list of MN-native plants",
    date = "2020-01-17"
  ),
  body(
    navbar(),
    h2("Native Plants"),
    div(
      class="row",
      div(
        class="col width-3 inputs-panel bordered",
        h2("Filter"),
        div(
          class = "row",
          div(
            class = "left width-8",
            label(`for`="type", "Type of Plant"),
            map(1:7, ~ label(input(type="checkbox", id=paste0("type-", .x), name="type", checked=NA), TYPES[.x]))
          ),
          div(
            class = "left width-4",
            label(`for`="zone", "Zone"),
            map(1:4, ~ label(input(type="checkbox", id=paste0("zone-", .x), name="zone", checked=NA), paste("Zone", .x)))
          )
        ),
        div(
          class = "text-center centered mn",
          "Region of MN"
        ),
        map(0:2, function(r) {
          div(
            class = "row centered mn",
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
          class = "centered mn mn-region",
          input(type="checkbox", id="mn-unk", checked=NA),
          label(`for`="mn-unk", class="text-center", "?")
        ),
        div(
          class = "row",
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
          class = "row",
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
          class = "row",
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
          label(`for`="feature", "Notable Feature"),
          select(
            id="feature",
            option(value="no filter", "no filter"),
            option(value="prairie", "native to prairie"),
            option(value="deciduousforest", "native to deciduous forest"),
            option(value="coniferousforest", "native to coniferous forest"),
            option(value="butterflynectar", "good for butterfly nectar"),
            option(value="butterflylarval", "good for butterfly larvae"),
            option(value="hummingbirds", "good for hummingbirds"),
            option(value="moistsoil", "good for moist soil"),
            option(value="pond", "good for ponds"),
            option(value="shallowwater", "good for shallow water"),
            option(value="rocksunny", "good for rocks (sunny)"),
            option(value="rockshady", "good for rocks (shady)"),
            option(value="groundcover", "good for groundcover"),
            option(value="deerresistant", "good for deer resistance"),
            option(value="shadegarden", "good for shade gardens"),
            option(value="mixedborder", "good for mixed borders"),
            option(value="frontyardsunny", "good for front yards (sunny)"),
            option(value="frontyardshady", "good for front yards (shady)"),
            option(value="frontyardwoody", "good for front yards (woody)")
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
        div(class="scroller-x", tab),
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
