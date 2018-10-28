
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

function mayopresets(premium, ppdeduct, famdeduct, ppoopm, famoopm, column)
{
  document.getElementById("premium" + column).value = premium;
  document.getElementById("ppdeduct" + column).value = ppdeduct;
  document.getElementById("famdeduct" + column).value = famdeduct;
  document.getElementById("ppoopm" + column).value = ppoopm;
  document.getElementById("famoopm" + column).value = famoopm;
}
function mayopremier(){mayopresets(310*12, 500, 1000, 2500, 5000, 1);}
function mayoselect(){mayopresets(175*12, 1000, 2000, 4000, 8000, 1);}
function mayobasic(){mayopresets(45*12, 4000, 4000, 5000, 10000, 2);}

function medicalplan(costs, copays, ppdeduct, famdeduct, ppoopm, famoopm)
{
  var totalSpent = 0;
  var spentDeduct = 0;
  var coi = Number(document.getElementById("coi").value) / 100;
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
  var costs1 = [
    document.getElementById("cost11").value,
    document.getElementById("cost21").value,
    document.getElementById("cost31").value,
    document.getElementById("cost41").value
  ];
  var costs2 = [
    document.getElementById("cost12").value,
    document.getElementById("cost22").value,
    document.getElementById("cost32").value,
    document.getElementById("cost42").value
  ];
  var copays1 = [
    document.getElementById("copay11").value,
    document.getElementById("copay21").value,
    document.getElementById("copay31").value,
    document.getElementById("copay41").value
  ];
  var copays2 = [
    document.getElementById("copay12").value,
    document.getElementById("copay22").value,
    document.getElementById("copay32").value,
    document.getElementById("copay42").value
  ];

  var premium1 = Number(document.getElementById("premium1").value);
  var premium2 = Number(document.getElementById("premium2").value);
  var ppdeduct1 = Number(document.getElementById("ppdeduct1").value);
  var ppdeduct2 = Number(document.getElementById("ppdeduct2").value);
  var famdeduct1 = Number(document.getElementById("famdeduct1").value);
  var famdeduct2 = Number(document.getElementById("famdeduct2").value);
  var ppoopm1 = Number(document.getElementById("ppoopm1").value);
  var ppoopm2 = Number(document.getElementById("ppoopm2").value);
  var famoopm1 = Number(document.getElementById("famoopm1").value);
  var famoopm2 = Number(document.getElementById("famoopm2").value);

  var fsa = Number(document.getElementById("fsa").value);
  var oop1 = Math.max(fsa, medicalplan(costs1, copays1, ppdeduct1, famdeduct1, ppoopm1, famoopm1)) +
    premium1;
  var oop2 = medicalplan(costs2, copays2, ppdeduct2, famdeduct2, ppoopm2, famoopm2) + premium2;

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
