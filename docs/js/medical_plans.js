
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
  mayopremier();

  linkOverlays();
}

function updateCoverage()
{
  mayobasic();
  mayopremier();
  (toggle(this))();
  if(gid("coverage").value == "single")
  {
    gid("fsahsa2").max = 3500;
  } else gid("fsahsa2").max = 7000;
}

function mayopresets(singlepremium, singlededuct, singleoopm,
                     fampremium, ppdeduct, famdeduct, ppoopm, famoopm,
                     coi, singlefsahsa, famfsahsa, column)
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
  calcMoney();
}
function mayopremier(){mayopresets(105*12, 500, 2500, 310*12, 500, 1000, 2500, 5000, 20, 2500, 2650, 1);}
function mayoselect(){mayopresets(60*12, 1000, 4000, 175*12, 1000, 2000, 4000, 8000, 20, 2650, 2650, 1);}
function mayobasic(){mayopresets(20*12, 2000, 5000, 45*12, 4000, 4000, 5000, 10000, 20, 3500, 7000, 2);}

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
  var premium1 = Number(gid("premium1").value);
  var premium2 = Number(gid("premium2").value);

  var fsa = Number(gid("fsahsa1").value);
  var oop1 = Math.max(fsa, medicalplan(1)) + premium1;
  var oop2 = medicalplan(2) + premium2;

  gid("oop1").innerHTML = '$' + oop1.toFixed(2);
  gid("oop2").innerHTML = '$' + oop2.toFixed(2);

  // fsa and hsa
  var hsa = Number(gid("fsahsa2").value);
  var tax = Number(gid("currTax").value) / 100;
  var ror = Number(gid("rorHSA").value) / 100;
  var freqContribs = Number(gid("freqContribs").value);

  var fsaSavings = tax * (fsa + premium1);
   // minus hsa because we're adding it in when we calculate our interest gained
  var hsaSavings = (tax * (hsa + premium2)) - hsa;
  for(var i=1; i <= freqContribs; i++)
  {
    hsaSavings += (hsa / freqContribs) * Math.pow(1 + ror, i / freqContribs);
  }
  gid("savings1").innerHTML = '$' + fsaSavings.toFixed(2);
  gid("savings2").innerHTML = '$' + hsaSavings.toFixed(2);
  gid("total1").innerHTML = '$' + (oop1 - fsaSavings).toFixed(2);
  gid("total2").innerHTML = '$' + (oop2 - hsaSavings).toFixed(2);
}
