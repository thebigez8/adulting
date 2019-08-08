

html(
  class = "finance theme-bg",
  HTMLhead(
    titl = "Mortgage Comparison", js = "mortgage_comparison",
    desc = "A comparison of two mortgages",
    date = "2019-07-30"
  ),
  body(
    navbar(),
    disclaimer(
      "This app is only intended to be used as a guide to help decide ",
      "which mortgage to select. It is a simplification, and as such, actual costs and savings ",
      "may differ from what is presented here."
    ),
    div(
      class="row",
      div(
        class="col width-3 inputs-panel bordered",
        h2("Input"),
        label(`for`="mortgage", "Mortgage"),
        select(
          id="mortgage",
          option(value="180", "15 year fixed"),
          option(value="360", "30 year fixed", selected = "selected")
        ),
        label(`for`="inflation", "Inflation Rate (%)"),
        input(type="number", id="inflation", value=2, step=1, min=0)
      ),
      div(
        class = "col width-9 outputs-panel",
        tags$table(
          thead(tr(th(), th("Loan 1"), th("Loan 2"))),
          tbody(
            class="inputs-table thickbottom",
            tr(
              th("Loan amount"),
              td(input(type="number", id="loan1", step=1000, min=0, value=250000)),
              td(input(type="number", id="loan2", step=1000, min=0, value=250000))
            ),
            tr(
              th("Rate (%)"),
              td(input(type="number", id="rate1", value=3.750, step=0.125, min=0, max=50)),
              td(input(type="number", id="rate2", value=3.875, step=0.125, min=0, max=50))
            ),
            tr(
              th("Fees or credits to get this loan (e.g., points)"),
              td(input(type="number", id="fee1", step=100, value=1000)),
              td(input(type="number", id="fee2", step=100, value=0))
            )
          ),
          tbody(
            class="outputs-table",
            tr(
              th("Total paid (in today's dollars)"),
              td(id="total1"),
              td(id="total2")
            ),
            tr(
              th("Monthly mortgage payments"),
              td(id="monthly1"),
              td(id="monthly2")
            ),
            tr(
              th("Which is better?"),
              td(id="breakeven", colspan=2)
            )
          )
        )
      )
    )
  )
) %>%
  write2file(file = "docs/finance/mortgage_comparison.html")
