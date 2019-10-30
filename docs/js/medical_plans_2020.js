
function init()
{
  var inputs = document.getElementsByTagName("input");
  for(var i=0; i < inputs.length; i++)
  {
    if(inputs[i].type == "number") inputs[i].addEventListener("change", validateNumber);
    inputs[i].addEventListener("change", calcMoney);
  }
  gid("freqContribs").addEventListener("change", calcMoney);
  gid("coverage").addEventListener("change", updateCoverage);
  gid("mayobasic").addEventListener("click", mayobasic);
  gid("mayoselect").addEventListener("click", mayoselect);
  gid("mayopremier").addEventListener("click", mayopremier);

  mayobasic();
  mayoselect();
  mayopremier();

  linkOverlays();

}

function updateCoverage()
{
  mayobasic();
  mayoselect();
  mayopremier();
  (toggle(this))();
  if(gid("coverage").value == "single")
  {
    gid("fsahsa3").max = 3550;
  } else gid("fsahsa3").max = 7100;
}

function mayopresets(singlepremium, singlededuct, singleoopm,
                     fampremium, ppdeduct, famdeduct, ppoopm, famoopm,
                     coi, singlefsahsa, famfsahsa, rollover, column)
{
  if(gid("coverage").value == "single")
  {
    for(var i = 2; i <= 4; i++)
    {
      gid("cost" + i + column).value = 0;
      gid("copay" + i + column).value = 0;
    }
    fampremium = singlepremium;
    ppdeduct = singlededuct;
    famdeduct = singlededuct;
    ppoopm = singleoopm;
    famoopm = singleoopm;
    famfsahsa = singlefsahsa;
  }
  gid("premium" + column).value = fampremium;
  gid("ppdeduct" + column).value = ppdeduct;
  gid("famdeduct" + column).value = famdeduct;
  gid("ppoopm" + column).value = ppoopm;
  gid("famoopm" + column).value = famoopm;
  gid("coi" + column).value = coi;
  gid("fsahsa" + column).value = famfsahsa;
  gid("rollover" + column).value = rollover;
  calcMoney();
}
function mayopremier(){mayopresets(110*12, 500, 2500, 320*12, 500, 1000, 2500, 5000, 20, 2700, 2700, 500, 1);}
function mayoselect(){mayopresets(65*12, 1000, 4000, 180*12, 1000, 2000, 4000, 8000, 20, 2700, 2700, 500, 2);}
function mayobasic(){mayopresets(20*12, 2000, 5000, 45*12, 4000, 4000, 5000, 10000, 20, 3550, 7100, 7100, 3);}

function medicalplan(column)
{
  var ppdeduct = Number(gid("ppdeduct" + column).value);
  var famdeduct = Number(gid("famdeduct" + column).value);
  var ppoopm = Number(gid("ppoopm" + column).value);
  var famoopm = Number(gid("famoopm" + column).value);
  var coi = Number(gid("coi" + column).value) / 100;
  var costs = [
    gid("cost1" + column).value,
    gid("cost2" + column).value,
    gid("cost3" + column).value,
    gid("cost4" + column).value
  ];
  var copays = [
    gid("copay1" + column).value,
    gid("copay2" + column).value,
    gid("copay3" + column).value,
    gid("copay4" + column).value
  ];
  return costs_of_plan(ppdeduct, famdeduct, ppoopm, famoopm, coi, costs, copays);
}

function costs_of_plan(ppdeduct, famdeduct, ppoopm, famoopm, coi, costs, copays)
{
  var totalSpent = 0;
  var spentDeduct = 0;
  for(var i=0; i < costs.length; i++)
  {
    var cost = Number(costs[i]);
    var towardoop = 0;
    if(spentDeduct >= famdeduct)
    {
      // Family has already hit deductible; everything here is coinsurance up to ppoopm
      towardoop = coi*cost;
    } else if(spentDeduct + Math.min(cost, ppdeduct) >= famdeduct)
    {
      // this person hits the family deductible before their own
      var amt = famdeduct - spentDeduct;
      towardoop = amt + coi*(cost - amt);
      spentDeduct = famdeduct;
    } else if(cost >= ppdeduct)
    {
      // this person hits the per-person deductible but not the family one
      towardoop = ppdeduct + coi*(cost - ppdeduct);
      spentDeduct += ppdeduct;
    } else
    {
      // this person misses both deductibles
      towardoop = cost;
      spentDeduct += cost;
    }
    totalSpent += Math.min(Number(copays[i]) + towardoop, ppoopm);
    if(totalSpent >= famoopm)
    {
      return famoopm;
    }
  }
  return totalSpent;
}

function get_total_costs(costofplan, premium, fsahsa, rollover, tax, ror, freqContribs, isHDHP)
{
  var oop;
  if(isHDHP)
  {
    oop = costofplan + premium;
  } else
  {
    oop = Math.max(fsahsa - rollover, costofplan) + premium;
  }
  var savings;
  if(isHDHP)
  {
    // minus hsa because we're adding it in when we calculate our interest gained
    savings = (tax * (fsahsa + premium)) - fsahsa;
    for(var i=1; i <= freqContribs; i++)
    {
      savings += (fsahsa / freqContribs) * Math.pow(1 + ror, i / freqContribs);
    }
  } else
  {
    savings = tax * (fsahsa + premium);
  }
  return {oop: oop, savings: savings, total: oop - savings};
}

function updateCosts(column)
{
  var costs = get_total_costs(
    medicalplan(column),
    Number(gid("premium" + column).value),
    Number(gid("fsahsa" + column).value),
    Number(gid("rollover" + column).value),
    Number(gid("currTax").value) / 100,
    Number(gid("rorHSA").value) / 100,
    Number(gid("freqContribs").value),
    column == 3
  );
  gid("oop" + column).innerHTML = '$' + costs.oop.toFixed(2);
  gid("savings" + column).innerHTML = '$' + costs.savings.toFixed(2);
  gid("total" + column).innerHTML = '$' + costs.total.toFixed(2);
}

function calcMoney()
{
  updateCosts(1);
  updateCosts(2);
  updateCosts(3);
  make_plotly();
}
