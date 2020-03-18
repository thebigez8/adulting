
html(
  class = "finance theme-bg",
  HTMLhead(
    titl = "2019 Tax Estimator", js = c("toggle", "overlay", "taxes"),
    desc = "A very simple 2019 tax estimation tool",
    date = "2019-07-10"
  ),
  body(
    navbar(),
    disclaimer(
      "This app is only intended to be used as a estimator, to get a general idea of your ",
      "tax burden. It is a simplification, and as such, actual taxes may differ ",
      "from what is presented here."
    ),
    h2("2019 Tax Estimator"),
    # p0("Note that 2018 tax reforms did away with exemptions."),
    div(
      class="row inputs-panel-group bordered",
      div(
        class="col width-3 inputs-panel",
        h3("Basic Info"),
        label(`for`="filing", "Filing Status"),
        select(
          id="filing",
          class = "toggler", `data-target` = "spouse",
          option(value="single", "Single"),
          option(value="joint", "Married filing Jointly", selected="selected")
        ),
        div(
          class = "row",
          div(
            class = "left width-6",
            label(
              `for`="over65",
              input(type="checkbox", id="over65"),
              "Over 65?"
            )
          ),
          div(
            class = "left width-6",
            label(
              `for`="blind",
              input(type="checkbox", id="blind"),
              "Blind?"
            )
          )
        ),
        div(
          class = "row toggleable spouse",
          div(
            class = "left width-6",
            label(
              `for`="over65spouse",
              input(type="checkbox", id="over65spouse"),
              "Spouse Over 65?"
            )
          ),
          div(
            class = "left width-6",
            label(
              `for`="blindspouse",
              input(type="checkbox", id="blindspouse"),
              "Spouse Blind?"
            )
          )
        )
      ),
      div(
        class = "col width-3 inputs-panel",
        h3("Income"),
        label(`for`="wages", "Wages"),
        input(type="number", id="wages", value=70000, step=1000, min=0),
        div(
          class = "toggleable spouse",
          label(`for`="wagesspouse", "Wages (spouse)"),
          input(type="number", id="wagesspouse", value=70000, step=1000, min=0)
        ),
        label(`for`="otherincome", "Other Income (interest, capital gains, etc.)"),
        input(type="number", id="otherincome", value=0, step=1000, min=0)
      ),
      div(
        class="col width-3 inputs-panel",
        h3("Federal Deductions"),
        div(
          class = "row",
          div(class = "left", label(`for`="deductions", "Federal Tax Deductions")),
          div(class = "left", overlay(
            "deductions-help", button.class = "finance",
            "Count here any pre-tax payroll deductions: contributions to 401(k) or 403(b) plans, ",
            "contributions to HSAs or FSAs, health insurance, etc."
          ))
        ),
        input(type="number", id="deductions", value=2800, step=1000, min=0),
        div(
          class = "toggleable spouse",
          label(`for`="deductionsspouse", "Federal Tax Deductions (spouse)"),
          input(type="number", id="deductionsspouse", value=2800, step=1000, min=0)
        ),
        div(
          class = "row",
          label(`for`="standard", HTML("Standard or Itemized Deduction<br>(whichever is larger)")),
          div(
            class = "left width-6",
            input(type="number", id="standard", value=0, readonly="readonly")
          ),
          div(
            class = "left width-6",
            input(type="number", id="itemized", value=0, step=1000, min=0)
          )
        )
      ),
      div(
        class="col width-3 inputs-panel",
        h3("Federal Credits"),
        label(`for`="credits", "Federal Tax Credits"),
        input(type="number", id="credits", value=0, step=1000, min=0)
      )
    ),
    div(
      class="row inputs-panel-group bordered",
      div(
        class = "col inputs-panel width-3",
        h3("FICA taxes"),
        div(
          class = "row",
          div(class = "left", label(`for`="fica", "Portion of Federal Deduction that is FICA-free")),
          div(class = "left", overlay(
            "fica-help", button.class = "finance",
            "Some of the federal deductions above are also not subject to FICA tax, including ",
            "health insurance premiums, contributions to HSAs and FSAs, and small amounts of ",
            "group universal life premiums."
          ))
        ),
        input(type="number", id="fica", value=0, step=1000, min=0),
        div(
          class = "toggleable spouse",
          label(`for`="ficaspouse", "Portion of Spouse's Federal Deduction that is FICA-free"),
          input(type="number", id="ficaspouse", value=0, step=1000, min=0)
        )
      ),
      div(
        class = "col inputs-panel width-3",
        h3("State"),
        div(
          class = "row",
          div(class = "left", label(`for`="state", "State")),
          div(class = "left", overlay(
            "state-help", button.class = "finance",
            "MN has 4 tax brackets in 2019: 5.35%, 6.80% (as of May), 7.85%, and 9.85%. ",
            "It also now follows the same standard deduction schema that the federal taxes use."
          ))
        ),
        select(
          id="state",
          option(value="mn", "Minnesota")
        )
      ),
      div(
        class = "col inputs-panel width-3",
        h3("State Deductions"),
        div(
          class = "row",
          div(class = "left", label(`for`="statedeductions", "Additional State Tax Deductions")),
          div(class = "left", overlay(
            "state-deductions-help", button.class = "finance",
            "States sometimes allow additional deductions beyond what Federal taxes allow. Enter those here."
          ))
        ),
        input(type="number", id="statedeductions", value=0, step=1000, min=0),
        div(
          class = "row",
          div(class = "left", label(`for`="stateexemptions", "State Tax Exemptions")),
          div(class = "left", overlay(
            "state-exemptions-help", button.class = "finance",
            "MN allows for deductions up to $4250 per dependent in 2019."
          ))
        ),
        input(type="number", id="stateexemptions", value=0, step=1000, min=0)
      ),
      div(
        class = "col inputs-panel width-3",
        h3("State Credits"),
        label(`for`="statecredits", "State Tax Credits"),
        input(type="number", id="statecredits", value=0, step=1000, min=0)
      )
    ),
    div(
      class = "row inputs-panel-group scroller-x",
      div(
        class = "col width-12 outputs-panel",
        tags$table(
          thead(tr(
            th(),
            th("Federal"),
            th("FICA (Social Security)"),
            th("FICA (Medicare)"),
            th("State"),
            th("Total Taxes")
          )),
          tbody(
            tr(
              th("Taxable Income"),
              td(id="taxablefed"),
              td(id="taxabless"),
              td(id="taxablemed"),
              td(id="taxablestate"),
              td()
            ),
            tr(
              th("Marginal Tax Rate"),
              td(id="marginalfed"),
              td(id="marginalss"),
              td(id="marginalmed"),
              td(id="marginalstate"),
              td()
            ),
            tr(
              class = "thickbottom",
              th("Effective Tax Rate"),
              td(id="effectivefed"),
              td(id="effectivess"),
              td(id="effectivemed"),
              td(id="effectivestate"),
              td(id="effectivetotal")
            ),
            tr(
              th("Taxes Owed"),
              td(id="fedtaxes"),
              td(id="sstaxes"),
              td(id="medtaxes"),
              td(id="statetaxes"),
              td(id="totaltaxes")
            )
          )
        )
      )
    )
  )
) %>%
  write2file(file = "docs/finance/tax_estimator_2019.html")
