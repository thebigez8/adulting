
function init()
{
  var inputs = document.getElementsByTagName("input");
  for(var i=0; i < inputs.length; i++)
  {
    inputs[i].addEventListener("change", calcMoney);
  }
  document.getElementById("freqContribs").addEventListener("change", calcMoney);
  document.getElementById("mayobasic").addEventListener("click", mayobasic);
  document.getElementById("mayoselect").addEventListener("click", mayoselect);
  document.getElementById("mayopremier").addEventListener("click", mayopremier);

  mayoselect();
  mayobasic();
  calcMoney();
}

function mayopresets(premium, ppdeduct, famdeduct, ppoopm, famoopm, coi, column)
{
  document.getElementById("premium" + column).value = premium;
  document.getElementById("ppdeduct" + column).value = ppdeduct;
  document.getElementById("famdeduct" + column).value = famdeduct;
  document.getElementById("ppoopm" + column).value = ppoopm;
  document.getElementById("famoopm" + column).value = famoopm;
  document.getElementById("coi" + column).value = coi;
  calcMoney();
}
function mayopremier(){mayopresets(310*12, 500, 1000, 2500, 5000, 20, 1);}
function mayoselect(){mayopresets(175*12, 1000, 2000, 4000, 8000, 20, 1);}
function mayobasic(){mayopresets(45*12, 4000, 4000, 5000, 10000, 20, 2);}

function medicalplan(column)
{
  var ppdeduct = Number(document.getElementById("ppdeduct" + column).value);
  var famdeduct = Number(document.getElementById("famdeduct" + column).value);
  var ppoopm = Number(document.getElementById("ppoopm" + column).value);
  var famoopm = Number(document.getElementById("famoopm" + column).value);
  var coi = Number(document.getElementById("coi" + column).value) / 100;
  var costs = [
    document.getElementById("cost1" + column).value,
    document.getElementById("cost2" + column).value,
    document.getElementById("cost3" + column).value,
    document.getElementById("cost4" + column).value
  ];
  var copays = [
    document.getElementById("copay1" + column).value,
    document.getElementById("copay2" + column).value,
    document.getElementById("copay3" + column).value,
    document.getElementById("copay4" + column).value
  ];

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

function calcMoney()
{
  var premium1 = Number(document.getElementById("premium1").value);
  var premium2 = Number(document.getElementById("premium2").value);

  var fsa = Number(document.getElementById("fsa").value);
  var oop1 = Math.max(fsa, medicalplan(1)) + premium1;
  var oop2 = medicalplan(2) + premium2;

  document.getElementById("oop1").innerHTML = '$' + oop1.toFixed(2);
  document.getElementById("oop2").innerHTML = '$' + oop2.toFixed(2);

  // fsa and hsa
  var hsa = Number(document.getElementById("hsa").value);
  var tax = Number(document.getElementById("currTax").value) / 100;
  var ror = Number(document.getElementById("rorTaxSavings").value) / 100;
  var freqContribs = Number(document.getElementById("freqContribs").value);

  var fsaSavings = tax * (fsa + premium1);
   // minus hsa because we're adding it in when we calculate our interest gained
  var hsaSavings = (tax * (hsa + premium2)) - hsa;
  for(var i=1; i <= freqContribs; i++)
  {
    hsaSavings += (hsa / freqContribs) * Math.pow(1 + ror, i / freqContribs);
  }
  document.getElementById("savings1").innerHTML = '$' + fsaSavings.toFixed(2);
  document.getElementById("savings2").innerHTML = '$' + hsaSavings.toFixed(2);
  document.getElementById("total1").innerHTML = '$' + (oop1 - fsaSavings).toFixed(2);
  document.getElementById("total2").innerHTML = '$' + (oop2 - hsaSavings).toFixed(2);
}
