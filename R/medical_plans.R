
html(
  HTMLhead(
    titl = "Medical Plan Comparison", "../js/medical_plans.js",
    keywords = "Medical Plans,HSA,FSA,High Deductible,Premiums,Deductible,Copay,Calculator",
    desc = "A comparison of two medical plans"
  ),
  body(
    navbar(),
    div(
      class="row",
      div(
        class="col width-3 inputs-panel bordered",
        h2("Input"),
        label(`for`="coi", "Coinsurance Rate"),
        input(type="number", id="coi", value=20, step=1),
        label(`for`="currTax", "Current Tax Rate"),
        input(type="number", id="currTax", value=20, step=1),
        label(`for`="rorTaxSavings", "Rate of Return on Tax Savings"),
        input(type="number", id="rorTaxSavings", value=5, step=1),
        label(`for`="freqContribs", "Frequency of FSA/HSA Contributions"),
        select(
          id="freqContribs",
          option(value=26, "Every Other Week"),
          option(value=24, "Twice per Month"),
          option(value=12, "Once per Month")
        ),
        button("Calculate!", id = "submit")
      ),
      div(
        class = "col width-9 outputs-panel",
        p0(
          "This table demonstrates the relative value of a High Deductible Health Plan (HDHP) vs. a ",
          "traditional health plan."
        ),
        tags$table(
          class="border-collapse",
          thead(tr(th(), th("Traditional"), th("High Deductible"))),
          tbody(
            class="inputs-table",
            tr(
              th("Yearly Premiums"),
              td(input(type="number", id="premium1", value=1920, step=1)),
              td(input(type="number", id="premium2", value=504, step=1))
            ),
            tr(
              th("Per-Person Deductible"),
              td(input(type="number", id="ppdeduct1", value=1000, step=1)),
              td(input(type="number", id="ppdeduct2", value=4000, step=1))
            ),
            tr(
              th("Family Deductible"),
              td(input(type="number", id="famdeduct1", value=2000, step=1)),
              td(input(type="number", id="famdeduct2", value=4000, step=1))
            ),
            tr(
              th("Per-Person Out of Pocket Max"),
              td(input(type="number", id="ppoopm1", value=4000, step=1)),
              td(input(type="number", id="ppoopm2", value=5000, step=1))
            ),
            tr(
              th("Family Out of Pocket Max"),
              td(input(type="number", id="famoopm1", value=8000, step=1)),
              td(input(type="number", id="famoopm2", value=10000, step=1))
            ),
            tr(
              th("Yearly HSA/FSA contributions"),
              td(
                label(`for`="fsa", "FSA"),
                input(type="number", id="fsa", value=2650, step=1)
              ),
              td(
                label(`for`="hsa", "HSA"),
                input(type="number", id="hsa", value=3450, step=1)
              )
            )
          ),
          tbody(
            class="inputs-table bordered",
            tr(
              th("Person 1 Medical Expenses"),
              td(input(type="number", id="cost11", value=10000, step=1)),
              td(input(type="number", id="cost12", value=10000, step=1))
            ),
            tr(
              th("Person 1 Copays"),
              td(input(type="number", id="copay11", value=25, step=1)),
              td(input(type="number", id="copay12", value=25, step=1))
            ),
            tr(
              th("Person 2 Medical Expenses"),
              td(input(type="number", id="cost21", value=5000, step=1)),
              td(input(type="number", id="cost22", value=5000, step=1))
            ),
            tr(
              th("Person 2 Copays"),
              td(input(type="number", id="copay21", value=25, step=1)),
              td(input(type="number", id="copay22", value=25, step=1))
            ),
            tr(
              th("Person 3 Medical Expenses"),
              td(input(type="number", id="cost31", value=500, step=1)),
              td(input(type="number", id="cost32", value=500, step=1))
            ),
            tr(
              th("Person 3 Copays"),
              td(input(type="number", id="copay31", value=0, step=1)),
              td(input(type="number", id="copay32", value=0, step=1))
            ),
            tr(
              th("Person 4 Medical Expenses"),
              td(input(type="number", id="cost41", value=0, step=1)),
              td(input(type="number", id="cost42", value=0, step=1))
            ),
            tr(
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


