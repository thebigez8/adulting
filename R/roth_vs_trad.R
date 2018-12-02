
retireTable <- function(ror = 1:20, retireTax = 35:5)
{
  rtaxRow <- function(r)
  {
    tr(
      if(r == retireTax[1]) th(id = "retiretax-th", div("Retirement Tax Rate"),
                               rowspan = length(retireTax)),
      th(r), map(ror, ~ td(0, id = paste0("cell-", r, "-", .x)))
    )
  }
  tags$table(
    id = "retireTable", class="width-12",
    thead(
      tr(th(), th(), th("Rate of Return on Retirement Savings", colspan=length(ror))),
      tr(th(), th(), map(ror, th))
    ),
    tbody(map(retireTax, rtaxRow))
  )
}


html(
  class = "finance",
  HTMLhead(
    titl = "Roth vs. Traditional", js = "roth_vs_trad",
    keywords = "Roth,Traditional,Retirement,Roth IRA,IRA,401(k),403(b)",
    desc = "A comparison of Roth vs. Traditional Retirement Accounts",
    date = "2018-09-15"
  ),
  body(
    navbar(),
    div(
      class="row",
      div(
        class="col width-3 inputs-panel bordered",
        h2("Input"),
        label(`for`="currAge", "Current Age"),
        input(type="number", id="currAge", value=25, step=1, min=0),
        label(`for`="retireAge", "Age at Retirement"),
        input(type="number", id="retireAge", value=65, step=1, min=0),
        label(`for`="contribs", "Yearly Contributions"),
        input(type="number", id="contribs", value=5000, min=0),
        label(`for`="currTax", "Current Tax Rate"),
        input(type="number", id="currTax", value=15, step=1, min=0, max=100),
        label(`for`="rorTaxSavings", "Rate of Return on Tax Savings"),
        input(type="number", id="rorTaxSavings", value=2, step=1, min=0),
        label(`for`="catchup", "Catch-Up Contributions?"),
        select(
          id="catchup",
          option(value=0, "None"),
          option(value=1000, "$1000 (as in an IRA)"),
          option(value=6000, "$6000 (as in a 401(k)")
        ),
        button("Calculate!", id = "submit")
      ),
      div(
        class = "col width-9 outputs-panel",
        p0(
          "This table demonstrates the value of a Roth Account over a traditional account ",
          "on the day your retire (after applicable taxes are taken out). Blue indicates that ",
          "the Roth performs better, whereas red indicates that the traditional performs better. ",
          "Hover over each cell to find the final value of each account."
        ),
        div(class="scroller-x", retireTable()),
        p0(
          "Assumptions: Tax savings from contributions to the tax-deferred account are invested ",
          "at the rate input, but the gains are taxed each year at the current tax rate. ",
          "All contributions are made at the beginning of the year and make the same ROR each year."
        )
      )
    )
  )
) %>%
  write2file(file = "docs/finance/roth_vs_trad.html")


