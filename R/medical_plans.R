
html(
  class = "finance",
  HTMLhead(
    titl = "Medical Plan Comparison", "../js/medical_plans.js", toggle = TRUE,
    keywords = "Medical Plans,HSA,FSA,High Deductible,Premiums,Deductible,Copay,Calculator",
    desc = "A comparison of two medical plans",
    date = "2018-09-18"
  ),
  body(
    navbar(),
    disclaimer(
      "This app is only intended to be used as a guide to help decide ",
      "which plan to select. It is a simplification, and as such, actual costs and savings may differ ",
      "from what is presented here."
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
        label(`for`="rorHSA", "Rate of Return on HSA"),
        input(type="number", id="rorHSA", value=5, step=1),
        label(`for`="currTax", "Current Tax Rate"),
        input(type="number", id="currTax", value=35, step=1),
        label(`for`="freqContribs", "Frequency of FSA/HSA Contributions"),
        select(
          id="freqContribs",
          option(value=26, "Every Other Week"),
          option(value=24, "Twice per Month"),
          option(value=12, "Once per Month")
        ),
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
          "This table demonstrates the relative value of a High Deductible Health Plan (HDHP) vs. a ",
          "traditional health plan."
        ),
        tags$table(
          thead(tr(th(), th("Traditional"), th("High Deductible"))),
          tbody(
            class="inputs-table",
            tr(
              th("Yearly Premiums"),
              td(input(type="number", id="premium1", step=1)),
              td(input(type="number", id="premium2", step=1))
            ),
            tr(
              th(span("Per-Person", class = "toggleable family"), "Deductible"),
              td(input(type="number", id="ppdeduct1", step=1)),
              td(input(type="number", id="ppdeduct2", step=1))
            ),
            tr(
              class = "toggleable family",
              th("Family Deductible"),
              td(input(type="number", id="famdeduct1", step=1)),
              td(input(type="number", id="famdeduct2", step=1))
            ),
            tr(
              th(span("Per-Person", class = "toggleable family"), "Out of Pocket Max"),
              td(input(type="number", id="ppoopm1", step=1)),
              td(input(type="number", id="ppoopm2", step=1))
            ),
            tr(
              class = "toggleable family",
              th("Family Out of Pocket Max"),
              td(input(type="number", id="famoopm1", step=1)),
              td(input(type="number", id="famoopm2", step=1))
            ),
            tr(
              th("Coinsurance Rate"),
              td(input(type="number", id="coi1", step=1)),
              td(input(type="number", id="coi2", step=1))
            ),
            tr(
              th("Yearly HSA/FSA contributions"),
              td(
                label(`for`="fsahsa1", "FSA"),
                input(type="number", id="fsahsa1", value=2700, step=1)
              ),
              td(
                label(`for`="fsahsa2", "HSA"),
                input(type="number", id="fsahsa2", value=7000, step=1)
              )
            )
          ),
          tbody(
            id = "expenses",
            class="inputs-table bordered",
            tr(
              th(span("Person 1", class = "toggleable family"), "Medical Expenses"),
              td(input(type="number", id="cost11", value=10000, step=1)),
              td(input(type="number", id="cost12", value=10000, step=1))
            ),
            tr(
              th(span("Person 1", class = "toggleable family"), "Copays"),
              td(input(type="number", id="copay11", value=0, step=1)),
              td(input(type="number", id="copay12", value=0, step=1))
            ),
            tr(
              class = "toggleable family",
              th("Person 2 Medical Expenses"),
              td(input(type="number", id="cost21", value=5000, step=1)),
              td(input(type="number", id="cost22", value=5000, step=1))
            ),
            tr(
              class = "toggleable family",
              th("Person 2 Copays"),
              td(input(type="number", id="copay21", value=0, step=1)),
              td(input(type="number", id="copay22", value=0, step=1))
            ),
            tr(
              class = "toggleable family",
              th("Person 3 Medical Expenses"),
              td(input(type="number", id="cost31", value=500, step=1)),
              td(input(type="number", id="cost32", value=500, step=1))
            ),
            tr(
              class = "toggleable family",
              th("Person 3 Copays"),
              td(input(type="number", id="copay31", value=0, step=1)),
              td(input(type="number", id="copay32", value=0, step=1))
            ),
            tr(
              class = "toggleable family",
              th("Person 4 Medical Expenses"),
              td(input(type="number", id="cost41", value=0, step=1)),
              td(input(type="number", id="cost42", value=0, step=1))
            ),
            tr(
              class = "toggleable family",
              th("Person 4 Copays"),
              td(input(type="number", id="copay41", value=0, step=1)),
              td(input(type="number", id="copay42", value=0, step=1))
            )
          ),
          tbody(
            class="outputs-table",
            tr(
              th("Out of Pocket Costs"),
              td(id="oop1"),
              td(id="oop2")
            ),
            tr(
              class = "thickbottom",
              th("Tax Savings + Interest Gained"),
              td(id="savings1"),
              td(id="savings2")
            ),
            tr(
              th("Grand Total"),
              td(id="total1"),
              td(id="total2")
            )
          )
        )
      )
    )
  )
) %>%
  write2file(file = "docs/finance/medical_plans.html")


