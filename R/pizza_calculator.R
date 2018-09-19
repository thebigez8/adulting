pizza <- function(i)
{
  div(
    class="col width-4 inputs-panel pizza-box",
    div(
      class="round bordered centered pizza",
      select(
        id = paste0("diam", i),
        option("Diameter of the pizza:", value=2),
        option("Radius of the pizza:", value=1)
      ),
      input(type = "number", id = paste0("size", i), value = 14 - 2*i),
      label(`for` = paste0("cost", i), "Price"),
      input(type = "number", id = paste0("cost", i),
            value = formatC(12.99 - 2*i, digits = 2, format = "f"))
    ),
    p(class = "width-6 centered", "Price per square unit:", span(id = paste0("ppsu", i)))
  )
}

html(
  HTMLhead(titl = "Pizza Calculator", script(src = "js/pizza_calculator.js")),
  body(
    navbar(),
    h2("Pizza Calculator"),
    div(
      class="row",
      pizza(1),
      pizza(2)
    )
  )
) %>%
  write2file(file = "docs/pizza_calculator.html")

