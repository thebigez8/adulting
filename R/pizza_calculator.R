pizza <- function(i)
{
  div(
    class="col width-4 inputs-panel pizza-box",
    div(
      class="round bordered centered pizza",
      select(
        id = paste0("diam", i),
        option("Pizza Diameter:", value=2),
        option("Pizza Radius:", value=1)
      ),
      input(type = "number", id = paste0("size", i), value = 14 - 2*i, step=0.5, min=0.5),
      label(`for` = paste0("cost", i), "Price"),
      input(type = "number", id = paste0("cost", i),
            value = formatC(12.99 - 2*i, digits = 2, format = "f"), step=0.01, min=0)
    ),
    p(class = "width-6 centered", "Price per square unit:", span(id = paste0("ppsu", i)))
  )
}

html(
  class = "finance theme-bg",
  HTMLhead(
    titl = "Pizza Calculator", js = "pizza_calculator",
    desc = "A calculator to determine which of two pizzas is a better price",
    date = "2018-09-19"
  ),
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
  write2file(file = "docs/finance/pizza_calculator.html")


