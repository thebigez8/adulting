
function init()
{
  var inputs = document.getElementsByTagName("input");
  for(var i=0; i < inputs.length; i++)
  {
    if(inputs[i].type == "number") inputs[i].addEventListener("change", validateNumber);
    if(inputs[i].type == "checkbox") inputs[i].addEventListener("change", updateFiling);
    inputs[i].addEventListener("change", calcTaxes);
  }
  gid("filing").addEventListener("change", updateFiling);
  gid("filing").addEventListener("change", calcTaxes);

  updateFiling();
  calcTaxes();
  linkOverlays();
}

function updateFiling()
{
  var val;
  var filingelt = gid("filing");
  var filing = filingelt.value;
  var over65 = gid("over65").checked;
  var blind = gid("blind").checked;
  var over65spouse = gid("over65spouse").checked;
  var blindspouse = gid("blindspouse").checked;
  if(filing == "single")
  {
    val = 12200 + 1650*(over65 + blind);
    if(!filingelt.classList.contains("inactive"))
    {
      (toggle(filingelt))();
    }
  } else if(filing == "joint")
  {
    val = 24400 + 1300*(over65 + blind + over65spouse + blindspouse);
    if(filingelt.classList.contains("inactive"))
    {
      (toggle(filingelt))();
    }
  }
  gid("standard").value = val;
}

function calcTaxes()
{
  var wages = Number(gid("wages").value);
  var wagesspouse = Number(gid("wagesspouse").value);
  var otherincome = Number(gid("otherincome").value);
  var filing = gid("filing").value;
  var standard = Number(gid("standard").value);
  var itemized = Number(gid("itemized").value);
  var deductions = Number(gid("deductions").value);
  var deductionsspouse = Number(gid("deductionsspouse").value);
  var credits = Number(gid("credits").value);

  var income = wages + otherincome;
  var federal = income - Math.max(standard, itemized) - deductions;
  if(filing == "joint")
  {
    income += wagesspouse;
    federal += wagesspouse - deductionsspouse;
  }
  var fedtaxes = getFederalTax(federal, filing) - credits;
  gid("taxablefed").innerHTML = "$" + federal.toFixed(2);
  gid("fedtaxes").innerHTML = "$" + fedtaxes.toFixed(2);
  gid("effectivefed").innerHTML = (100*fedtaxes/income).toFixed(2) + "%";

  ////
  var medtaxable = wages - Number(gid("fica").value);
  var medtaxes = getMedTaxes(medtaxable);
  var SStaxable = Math.min(medtaxable, 132900);
  var SStaxes = SStaxable*0.062;

  gid("marginalmed").innerHTML = (0.0145*100 + 0.009*100*(medtaxable > 200000)).toFixed(2) + "%";
  gid("marginalss").innerHTML = (0.062*100*(medtaxable <= 132900)).toFixed(2) + "%";

  if(filing == "joint")
  {
    var medtaxablespouse = wagesspouse - Number(gid("ficaspouse").value);
    medtaxes += getMedTaxes(medtaxablespouse);
    gid("marginalmed").innerHTML += " / " + (0.0145*100 + 0.009*100*(medtaxablespouse > 200000)).toFixed(2) + "%";
    medtaxable += medtaxablespouse;

    var SStaxablespouse = Math.min(medtaxablespouse, 132900);
    SStaxes += SStaxablespouse*0.062;
    gid("marginalss").innerHTML += " / " + (0.062*100*(medtaxablespouse <= 132900)).toFixed(2) + "%";
    SStaxable += SStaxablespouse;
  }

  gid("taxablemed").innerHTML = "$" + medtaxable.toFixed(2);
  gid("medtaxes").innerHTML = "$" + medtaxes.toFixed(2);
  gid("effectivemed").innerHTML = (100*medtaxes/income).toFixed(2) + "%";

  gid("taxabless").innerHTML = "$" + SStaxable.toFixed(2);
  gid("sstaxes").innerHTML = "$" + SStaxes.toFixed(2);
  gid("effectivess").innerHTML = (100*SStaxes/income).toFixed(2) + "%";

  gid("totaltaxes").innerHTML = "$" + (fedtaxes + medtaxes + SStaxes).toFixed(2);
  gid("effectivetotal").innerHTML = (100*(fedtaxes + medtaxes + SStaxes)/income).toFixed(2) + "%";
}

function getFederalTax(taxable, filing)
{
  var out = 0;
  var taxes = [0.1, 0.12, 0.22, 0.24, 0.32, 0.35, 0.37];
  var brackets;
  if(filing == "single")
  {
    brackets = [0, 9700, 39475, 84200, 160725, 204100, 510300, Infinity];
  } else   if(filing == "joint")
  {
    brackets = [0, 19400, 78950, 168400, 321450, 408200, 612350, Infinity];
  }
  for(var i = 0; i < taxes.length; i++)
  {
    out += taxes[i]*(Math.min(brackets[i+1], taxable) - brackets[i])*(taxable > brackets[i]);
    if(taxable > brackets[i])
    {
      gid("marginalfed").innerHTML = (100*taxes[i]).toFixed(2) + "%";
    }
  }
  return out;
}

function getMedTaxes(taxable)
{
  return taxable*0.0145 + Math.max(0, 0.009*(taxable - 200000));
}
