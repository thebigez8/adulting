fsahsahelp <- overlay(
  "fsa-hsa-help", button.class = "finance", as.html = TRUE,
  "There are different rules governing how much you can contribute to an ",
  "HSA vs. an FSA. In short, ", em("each plan holder"), " is allowed to contribute ",
  "$2650 in 2019 to an FSA (so that if you're on a family plan, you're stuck at $2650). On ",
  "the flip side, if you're on a single-coverage HDHP, you can contribute $3500 ",
  "in 2019 to an HSA, and $7000 if you have family coverage. Finally, note that ",
  "contributions to an FSA are usually lost (although some plans allow for small roll-overs), ",
  "so that you shouldn't contribute more to an FSA than your yearly expenses. On the other ",
  "hand, HSAs roll over (and can accrue interest!), so there's no need to limit contributions ",
  "based on yearly expenses. See ",
  a("this calculator's help page", href = "medical_plan_definitions.html"), " for more details."
)
copayshelp <- overlay(
  "copays-help", button.class = "finance", as.html = TRUE,
  "Note that copays are counted differently than normal medical expenses. ",
  "In general, copays count toward the out-of-pocket maximum, but not toward ",
  "a deductible. See ",
  a("this calculator's help page", href = "medical_plan_definitions.html"), " for more details."
)

html(
  class = "finance",
  HTMLhead(
    titl = "Medical Plan Comparison", js = c("toggle", "overlay", "medical_plans"),
    keywords = "Medical Plans,HSA,FSA,High Deductible,Premiums,Deductible,Copay,Calculator",
    desc = "A comparison of two medical plans",
    date = "2018-09-18"
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
          div(class="left", label(`for`="currTax", "Current Tax Rate")),
          div(class="left", overlay(
            "tax-help", button.class = "finance", as.html = TRUE,
            "Note that contributions to HSAs and FSAs, along with medical premiums, ",
            "are entirely tax-free. In other words, they are not subject to federal, ",
            "state, or FICA tax. See ",
            a("this calculator's help page", href = "medical_plan_definitions.html"),
            " for more details."
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
        input(type="number", id="rorHSA", value=5, step=1, min=0),
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
              td(input(type="number", id="premium1", step=1, min=0)),
              td(input(type="number", id="premium2", step=1, min=0))
            ),
            tr(
              th(span("Per-Person", class = "toggleable family"), "Deductible"),
              td(input(type="number", id="ppdeduct1", step=1, min=0)),
              td(input(type="number", id="ppdeduct2", step=1, min=0))
            ),
            tr(
              class = "toggleable family",
              th("Family Deductible"),
              td(input(type="number", id="famdeduct1", step=1, min=0)),
              td(input(type="number", id="famdeduct2", step=1, min=0))
            ),
            tr(
              th(span("Per-Person", class = "toggleable family"), "Out of Pocket Max"),
              td(input(type="number", id="ppoopm1", step=1, min=0)),
              td(input(type="number", id="ppoopm2", step=1, min=0))
            ),
            tr(
              class = "toggleable family",
              th("Family Out of Pocket Max"),
              td(input(type="number", id="famoopm1", step=1, min=0)),
              td(input(type="number", id="famoopm2", step=1, min=0))
            ),
            tr(
              th("Coinsurance Rate"),
              td(input(type="number", id="coi1", step=1, min=0)),
              td(input(type="number", id="coi2", step=1, min=0))
            ),
            tr(
              th(
                html0("Yearly HSA/FSA contributions", fsahsahelp[[1]]),
                fsahsahelp[[2]]
              ),
              td(
                label(`for`="fsahsa1", "FSA"),
                input(type="number", id="fsahsa1", value=2650, step=1, min=0, max=2650)
              ),
              td(
                label(`for`="fsahsa2", "HSA"),
                input(type="number", id="fsahsa2", value=7000, step=1, min=0, max=7000)
              )
            )
          ),
          tbody(
            id = "expenses",
            class="inputs-table bordered",
            tr(
              th(span("Person 1", class = "toggleable family"), "Medical Expenses"),
              td(input(type="number", id="cost11", value=10000, step=1, min=0)),
              td(input(type="number", id="cost12", value=10000, step=1, min=0))
            ),
            tr(
              th(
                html0(span("Person 1 ", class = "toggleable family"), "Copays", copayshelp[[1]]),
                copayshelp[[2]]
              ),
              td(input(type="number", id="copay11", value=0, step=1, min=0)),
              td(input(type="number", id="copay12", value=0, step=1, min=0))
            ),
            tr(
              class = "toggleable family",
              th("Person 2 Medical Expenses"),
              td(input(type="number", id="cost21", value=5000, step=1, min=0)),
              td(input(type="number", id="cost22", value=5000, step=1, min=0))
            ),
            tr(
              class = "toggleable family",
              th("Person 2 Copays"),
              td(input(type="number", id="copay21", value=0, step=1, min=0)),
              td(input(type="number", id="copay22", value=0, step=1, min=0))
            ),
            tr(
              class = "toggleable family",
              th("Person 3 Medical Expenses"),
              td(input(type="number", id="cost31", value=500, step=1, min=0)),
              td(input(type="number", id="cost32", value=500, step=1, min=0))
            ),
            tr(
              class = "toggleable family",
              th("Person 3 Copays"),
              td(input(type="number", id="copay31", value=0, step=1, min=0)),
              td(input(type="number", id="copay32", value=0, step=1, min=0))
            ),
            tr(
              class = "toggleable family",
              th("Person 4 Medical Expenses"),
              td(input(type="number", id="cost41", value=0, step=1, min=0)),
              td(input(type="number", id="cost42", value=0, step=1, min=0))
            ),
            tr(
              class = "toggleable family",
              th("Person 4 Copays"),
              td(input(type="number", id="copay41", value=0, step=1, min=0)),
              td(input(type="number", id="copay42", value=0, step=1, min=0))
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

dd0 <- function(..., as.html = FALSE) dd(if(as.html) html0(...) else paste0(...))
html(
  class = "finance",
  HTMLhead(
    titl = "Medical Plan Definitions", js = "blank",
    keywords = "Medical Plans,HSA,FSA,High Deductible,Premiums,Deductible,Copay",
    desc = "Definitions of relevant medical plan terminology.",
    date = "2018-11-11"
  ),
  body(
    navbar(),
    div(
      class="row",
      p0(
        as.html = TRUE,
        "Find below definitions and layman explanations of relevant medical plan terms (as used in ",
        a("this calculator", href = "medical_plans.html"), ")."
      ),
      div(
        class = "col width-6",
        h3("Basic Terminology"),
        dl(
          dt(dfn("Premium")),
          dd0(
            "A premium is how much you pay for medical insurance. Even if you never go to the ",
            "doctor, you will still pay premiums. In general, high-deductible health plans (HDHPs) ",
            "have lower premiums than traditional health plans."
          )
        ),
        dl(
          dt(dfn("Deductible")),
          dd0(
            "A deductible is how much you pay before your insurance plan pays for covered services. ",
            "High-deductible health plans are so named because they usually have higher deductibles ",
            "than traditional health plans, meaning that you'll pay more before insurance kicks in. ",
            "Do note that certain services (e.g., preventative services) may be covered even if you haven't ",
            "met your deductible (that is, paid for services that add up to the deductible)."
          )
        ),
        dl(
          dt(dfn("Per-Person/Family Deductibles")),
          dd0(
            "Under a family plan, deductibles get slightly trickier. An ", em("individual"),
            " deductible indicates that each member of the family will have to meet a deductible before ",
            "getting covered by insurance. Once an individual has met their deductible, insurance kicks in ",
            "for that individual, even if no other family member has met his/her deductible. ",
            "Fortunately, in family plans there's also a ", em("family"), " deductible. ",
            "Basically, once the amount that the family as a whole has paid in deductibles reaches ",
            "the family deductible, insurance kicks in for all family members, even those who haven't ",
            "reached their individual deductibles. Note that HDHPs may omit the individual deductible, ",
            "meaning that one individual may meet the family deductible on his/her own.",
            as.html = TRUE
          )
        ),
        dl(
          dt(dfn("Coinsurance")),
          dd0(
            "After an individual (or family) meets the deductible, insurance will pay for a portion of ",
            "services. ", em("Coinsurance"), " indicates the percentage of services you will pay for.",
            as.html = TRUE
          )
        ),
        dl(
          dt(dfn("Out of Pocket Maximum")),
          dd0(
            "The out of pocket maximum is the most you will pay for services. After you have met the OOPM, ",
            "insurance will cover all remaining services."
          )
        ),
        dl(
          dt(dfn("Per-Person/Family Out of Pocket Maximum")),
          dd0(
            "A ", em("per-person"), " OOPM indicates the most you'll pay for services for a single member ",
            "of the family. A ", em("family"), " OOPM indicates the most the family will pay for services as",
            "a whole", as.html = TRUE
          )
        ),
        dl(
          dt(dfn("Copay")),
          dd0(
            "A copay is how much you have to pay upfront to receive a service. In general, copays count ",
            "toward the OOPM, but not the deductible."
          )
        )
      ),
      div(
        class = "col width-6",
        h3("Advanced Terminology"),
        dl(
          dt(dfn("FSA")),
          dd0(
            "A Flexible Spending Account (FSA) is a pre-tax account used to cover medical expenses. It is ",
            "usually funded through payroll deductions, and it has a yearly contribution limit imposed ",
            "by the IRS ($2650 per FSA). Since it's pre-tax, you save money on taxes by contributing. ",
            "Note, however, that FSAs are usually use-it-or-lose-it. In other words, if you contribute ",
            "more to the FSA than you need for medical expenses, the rest is lost (although some plans ",
            "allow for a small roll-over from year to year). Finally, note also that you can't have an ",
            "FSA if you're enrolled in a HDHP."
          )
        ),
        dl(
          dt(dfn("HSA")),
          dd0(
            "A Health Savings Account (HSA) is similar to an FSA, in that it is a pre-tax account usually ",
            "funded by payroll deductions that is used to cover medical expenses. The IRS also imposes limits ",
            "on HSA contributions ($3500 for an individual, $7000 for a family). However, HSAs are not ",
            "use-it-or-lose-it, and money in the HSA can be invested (which makes it almost like a ",
            "tax-free retirement account if you don't touch the money for a while). You can only contribute ",
            "to an HSA if you're on a HDHP (but you can withdraw money to cover expenses at a later date, ",
            "even if you're no longer on a HDHP)."
          )
        ),
        dl(
          dt(dfn("Current Tax Rate")),
          dd0(
            "The current tax rate is used to calculate how much you save by paying pre-tax premiums ",
            "and by contributing to pre-tax accounts (FSA/HSA). To get a more accurate picture of tax ",
            "savings, input your ", em("marginal"), " tax rate (since in general these contributions and ",
            "payments save money from the highest bracket you're in). In particular, make sure this number ",
            "includes federal, state, ", em("and"), " FICA taxes, since it's tax-free for all three.",
            as.html = TRUE
          )
        ),
        dl(
          dt(html0(
            dfn("Frequency of FSA contributions"), " and ",
            dfn("Rate of Return on HSA contributions")
          )),
          dd0(
            "Since you can invest your HSA contributions, this calculator takes into account any money ",
            "you may have gained from such investments. If you don't invest the money (i.e., treat it like ",
            "a savings account or cash fund), set this to zero. The calculator also assumes that you ",
            "see the same rate of return all year long, and that any withdrawls occur at the end of the year ",
            "(which gives your money more time to grow, but still lets you reimburse yourself for medical ",
            "expenses). Finally, the frequency of contribution determines how much interest will accrue."
          )
        )
      )
    )
  )
) %>%
  write2file(file = "docs/finance/medical_plan_definitions.html")

