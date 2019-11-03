fsahsahelp <- overlay(
  "fsa-hsa-help", button.class = "finance", as.html = TRUE,
  "There are different rules governing how much you can contribute to an ",
  "HSA vs. an FSA. In short, ", em("each plan holder"), " is allowed to contribute ",
  "$2700 in 2020 to an FSA (so that if you're on a family plan, you're stuck at $2700). On ",
  "the flip side, if you're on a single-coverage HDHP, you can contribute $3550 ",
  "in 2020 to an HSA, and $7100 if you have family coverage. Finally, note that ",
  "contributions to an FSA are usually lost (although some plans allow for small roll-overs), ",
  "so that you shouldn't contribute more to an FSA than your yearly expenses. On the other ",
  "hand, HSAs roll over (and can accrue interest!), so there's no need to limit contributions ",
  "based on yearly expenses. Finally, note that if one spouse contributes to an FSA, the other is ",
  "no longer eligible to contribute to an HSA, even if the latter is covered by a HDHP. See ",
  a("this calculator's help page", href = "medical_plan_definitions.html"), " for more details."
)
copayshelp <- overlay(
  "copays-help", button.class = "finance", as.html = TRUE,
  "Note that copays are counted differently than normal medical expenses. ",
  "In general, copays count toward the out-of-pocket maximum, but not toward ",
  "a deductible. See ",
  a("this calculator's help page", href = "medical_plan_definitions.html"), " for more details."
)

showifsmalltr <- function(..., class = NULL)
{
  tr(
    class=paste("showifsmall", class),
    th(class="hideifsmall"),
    th(..., colspan=3)
  )
}

html(
  class = "finance theme-bg",
  HTMLhead(
    titl = "Medical Plan Comparison 2020",
    js = c("toggle", "overlay", "medical_plans_2020", "medical_plans_plot_2020"),
    desc = "A comparison of three medical plans",
    date = "2019-10-29",
    externaljs = "https://cdn.plot.ly/plotly-latest.min.js"
  ),
  body(
    navbar(),
    disclaimer(
      "This app is only intended to be used as a guide to help decide ",
      "which plan to select. It is a simplification, and as such, actual costs and savings may differ ",
      "from what is presented here. Please visit ",
      a("this calculator's help page", href = "medical_plan_definitions.html"),
      " for help and explanations.",
      as.html = TRUE
    ),
    div(
      class="row",
      div(
        class="col width-3 inputs-panel bordered",
        h2("Input"),
        label(`for`="coverage", "Coverage"),
        select(
          id="coverage",
          class = "toggler", `data-target` = "family",
          option(value="single", "Single"),
          option(value="family", "Family", selected = "selected")
        ),
        div(
          class="row",
          div(class="left", label(`for`="currTax", "Marginal Tax Rate")),
          div(class="left", overlay(
            "tax-help", button.class = "finance", as.html = TRUE,
            "Note that contributions to HSAs and FSAs, along with medical premiums, ",
            "are entirely tax-free. In other words, they are not subject to federal, ",
            "state, or FICA tax. See ",
            a("this calculator's help page", href = "medical_plan_definitions.html"),
            " for more details. See also ", a("this tax estimator", href = "tax_estimator_2019.html"), "."
          ))
        ),
        input(type="number", id="currTax", value=35, step=1, min=0, max=100),
        label(`for`="freqContribs", "Frequency of FSA/HSA Contributions"),
        select(
          id="freqContribs",
          option(value=26, "Every Other Week"),
          option(value=24, "Twice per Month"),
          option(value=12, "Once per Month")
        ),
        label(`for`="rorHSA", "Rate of Return on HSA"),
        input(type="number", id="rorHSA", value=0, step=1, min=0),
        label("Presets:"),
        div(
          class = "row",
          button(class = "left width-4", id = "mayopremier", "Premier"),
          button(class = "left width-4", id = "mayoselect", "Select"),
          button(class = "left width-4", id = "mayobasic", "Basic")
        )
      ),
      div(
        class = "col width-9 outputs-panel",
        p0(
          "This table demonstrates the relative value of a High Deductible Health Plan (HDHP) vs. ",
          "traditional health plans."
        ),
        tags$table(
          thead(tr(th(class="hideifsmall"), th("Traditional (lowest deductible)"),
                   th("Traditional (higher deductible)"), th("High Deductible"))),
          tbody(
            class="inputs-table",
            showifsmalltr("Yearly Premiums"),
            tr(
              th("Yearly Premiums", class="hideifsmall"),
              td(input(type="number", id="premium1", step=1, min=0)),
              td(input(type="number", id="premium2", step=1, min=0)),
              td(input(type="number", id="premium3", step=1, min=0))
            ),
            showifsmalltr(span("Per-Person", class = "toggleable family"), "Deductible"),
            tr(
              th(span("Per-Person", class = "toggleable family"), "Deductible", class="hideifsmall"),
              td(input(type="number", id="ppdeduct1", step=1, min=0)),
              td(input(type="number", id="ppdeduct2", step=1, min=0)),
              td(input(type="number", id="ppdeduct3", step=1, min=0))
            ),
            showifsmalltr("Family Deductible", class = "toggleable family"),
            tr(
              class = "toggleable family",
              th("Family Deductible", class="hideifsmall"),
              td(input(type="number", id="famdeduct1", step=1, min=0)),
              td(input(type="number", id="famdeduct2", step=1, min=0)),
              td(input(type="number", id="famdeduct3", step=1, min=0))
            ),
            showifsmalltr(span("Per-Person", class = "toggleable family"), "Out of Pocket Max"),
            tr(
              th(span("Per-Person", class = "toggleable family"), "Out of Pocket Max", class="hideifsmall"),
              td(input(type="number", id="ppoopm1", step=1, min=0)),
              td(input(type="number", id="ppoopm2", step=1, min=0)),
              td(input(type="number", id="ppoopm3", step=1, min=0))
            ),
            showifsmalltr("Family Out of Pocket Max", class = "toggleable family"),
            tr(
              class = "toggleable family",
              th("Family Out of Pocket Max", class="hideifsmall"),
              td(input(type="number", id="famoopm1", step=1, min=0)),
              td(input(type="number", id="famoopm2", step=1, min=0)),
              td(input(type="number", id="famoopm3", step=1, min=0))
            ),
            showifsmalltr("Coinsurance Rate"),
            tr(
              th("Coinsurance Rate", class="hideifsmall"),
              td(input(type="number", id="coi1", step=1, min=0)),
              td(input(type="number", id="coi2", step=1, min=0)),
              td(input(type="number", id="coi3", step=1, min=0))
            ),
            showifsmalltr(html0("Yearly HSA/FSA contributions", fsahsahelp[[1]])),
            tr(
              th(
                html0("Yearly HSA/FSA contributions", fsahsahelp[[1]]),
                class="hideifsmall"
              ),
              td(
                label(`for`="fsahsa1", "FSA"),
                input(type="number", id="fsahsa1", value=2700, step=1, min=0, max=2750)
              ),
              td(
                label(`for`="fsahsa2", "FSA"),
                input(type="number", id="fsahsa2", value=2700, step=1, min=0, max=2750)
              ),
              td(
                label(`for`="fsahsa3", "HSA"),
                input(type="number", id="fsahsa3", value=7100, step=1, min=0, max=7100)
              )
            ),
            showifsmalltr("Maximum Rollover"),
            tr(
              th("Maximum Rollover", class="hideifsmall"),
              td(input(type="number", id="rollover1", value=500, step=1, min=0)),
              td(input(type="number", id="rollover2", value=500, step=1, min=0)),
              td(input(type="number", id="rollover3", value=7100, step=1, min=0, style = "display:none"))
            )
          ),
          tbody(
            id = "expenses",
            class="inputs-table bordered",
            showifsmalltr(span("Person 1", class = "toggleable family"), "Medical Expenses"),
            tr(
              th(span("Person 1", class = "toggleable family"), "Medical Expenses", class="hideifsmall"),
              td(input(type="number", id="cost11", value=10000, step=1, min=0)),
              td(input(type="number", id="cost12", value=10000, step=1, min=0)),
              td(input(type="number", id="cost13", value=10000, step=1, min=0))
            ),
            showifsmalltr(html0(span("Person 1 ", class = "toggleable family"), "Copays", copayshelp[[1]])),
            tr(
              th(
                html0(span("Person 1 ", class = "toggleable family"), "Copays", copayshelp[[1]]),
                class="hideifsmall"
              ),
              td(input(type="number", id="copay11", value=0, step=1, min=0)),
              td(input(type="number", id="copay12", value=0, step=1, min=0)),
              td(input(type="number", id="copay13", value=0, step=1, min=0))
            ),
            showifsmalltr("Person 2 Medical Expenses", class = "toggleable family"),
            tr(
              class = "toggleable family",
              th("Person 2 Medical Expenses", class="hideifsmall"),
              td(input(type="number", id="cost21", value=5000, step=1, min=0)),
              td(input(type="number", id="cost22", value=5000, step=1, min=0)),
              td(input(type="number", id="cost23", value=5000, step=1, min=0))
            ),
            showifsmalltr("Person 2 Copays", class = "toggleable family"),
            tr(
              class = "toggleable family",
              th("Person 2 Copays", class="hideifsmall"),
              td(input(type="number", id="copay21", value=0, step=1, min=0)),
              td(input(type="number", id="copay22", value=0, step=1, min=0)),
              td(input(type="number", id="copay23", value=0, step=1, min=0))
            ),
            showifsmalltr("Person 3 Medical Expenses", class = "toggleable family"),
            tr(
              class = "toggleable family",
              th("Person 3 Medical Expenses", class="hideifsmall"),
              td(input(type="number", id="cost31", value=500, step=1, min=0)),
              td(input(type="number", id="cost32", value=500, step=1, min=0)),
              td(input(type="number", id="cost33", value=500, step=1, min=0))
            ),
            showifsmalltr("Person 3 Copays", class = "toggleable family"),
            tr(
              class = "toggleable family",
              th("Person 3 Copays", class="hideifsmall"),
              td(input(type="number", id="copay31", value=0, step=1, min=0)),
              td(input(type="number", id="copay32", value=0, step=1, min=0)),
              td(input(type="number", id="copay33", value=0, step=1, min=0))
            ),
            showifsmalltr("Person 4 Medical Expenses", class = "toggleable family"),
            tr(
              class = "toggleable family",
              th("Person 4 Medical Expenses", class="hideifsmall"),
              td(input(type="number", id="cost41", value=0, step=1, min=0)),
              td(input(type="number", id="cost42", value=0, step=1, min=0)),
              td(input(type="number", id="cost43", value=0, step=1, min=0))
            ),
            showifsmalltr("Person 4 Copays", class = "toggleable family"),
            tr(
              class = "toggleable family",
              th("Person 4 Copays", class="hideifsmall"),
              td(input(type="number", id="copay41", value=0, step=1, min=0)),
              td(input(type="number", id="copay42", value=0, step=1, min=0)),
              td(input(type="number", id="copay43", value=0, step=1, min=0))
            )
          ),
          tbody(
            class="outputs-table",
            showifsmalltr("Out of Pocket Costs"),
            tr(
              th("Out of Pocket Costs", class="hideifsmall"),
              td(id="oop1"),
              td(id="oop2"),
              td(id="oop3")
            ),
            showifsmalltr("Tax Savings + Interest Gained"),
            tr(
              class = "thickbottom",
              th("Tax Savings + Interest Gained", class="hideifsmall"),
              td(id="savings1"),
              td(id="savings2"),
              td(id="savings3")
            ),
            showifsmalltr("Grand Total"),
            tr(
              th("Grand Total", class="hideifsmall"),
              td(id="total1"),
              td(id="total2"),
              td(id="total3")
            )
          )
        ),
        fsahsahelp[[2]],
        copayshelp[[2]],
        p0("This plot shows the total cost of the three plans, holding fixed the costs for persons 2 - 4 ",
           "(if applicable) and person 1's copays, but varying person 1's medical expenses."),
        div(id = "vis")
      )
    )
  )
) %>%
  write2file(file = "docs/finance/medical_plans_2020.html")
