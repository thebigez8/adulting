
retireTable <- function(ror = 20:1, retireTax = 5:20)
{
  rorRow <- function(r)
  {
    tr(
      if(r == ror[1]) th(id = "ror-th", div("Rate of Return on Retirement Savings"),
                         rowspan = length(ror)),
      th(r), purrr::map(retireTax, ~ td(0, id = paste0("cell-", r, "-", .x)))
    )
  }
  tags$table(
    id = "retireTable", class="width-12",
    thead(
      tr(th(), th(), th("Retirement Tax Rate", colspan=length(retireTax))),
      tr(th(), th(), purrr::map(retireTax, th))
    ),
    tbody(purrr::map(ror, rorRow))
  )
}


html(
  HTMLhead(titl = "Roth vs. Traditional", script(src = "js/roth_vs_trad.js")),
  body(
    navbar(),
    div(
      class="row",
      div(
        class="col width-3 inputs-panel",
        h2("Input"),
        div(
          label(`for`="currAge", "Current Age"),
          input(type="number", id="currAge", value=25, step=1)
        ),
        div(
          label(`for`="retireAge", "Age at Retirement"),
          input(type="number", id="retireAge", value=65, step=1)
        ),
        div(
          label(`for`="contribs", "Yearly Contributions"),
          input(type="number", id="contribs", value=5000)
        ),
        div(
          label(`for`="currTax", "Current Tax Rate"),
          input(type="number", id="currTax", value=15, step=1)
        ),
        div(
          label(`for`="rorTaxSavings", "Rate of Return on Tax Savings"),
          input(type="number", id="rorTaxSavings", value=0, step=1)
        ),
        div(
          label(`for`="catchup", "Catch-Up Contributions?"),
          select(
            id="catchup",
            option(value=0, "None"),
            option(value=1000, "$1000 (as in an IRA)"),
            option(value=6000, "$6000 (as in a 401(k)")
          )
        ),
        div(
          button("Calculate!", id = "submit")
        )
      ),
      div(
        class = "col width-9 outputs-panel",
        p0(
          "This table demonstrates the value of a Roth Account over a traditional account ",
          "no the day your retire (after applicable taxes are taken out). Blue indicates that ",
          "the Roth performs better, whereas red indicates that the traditional performs better."
        ),
        retireTable(),
        p0(
          "Assumptions: Tax savings from contributions to the tax-deferred account are invested ",
          "at the rate input, but the gains are taxed each year at the current tax rate. ",
          "All contributions are made at the beginning of the year and make the same ROR each year."
        )
      )
    )
  )
) %>%
  write2file(file = "roth_vs_trad.html")


