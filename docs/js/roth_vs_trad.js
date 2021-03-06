
function init()
{
  var inputs = document.getElementsByTagName("input");
  for(var i=0; i < inputs.length; i++)
  {
    if(inputs[i].type == "number") inputs[i].addEventListener("change", validateNumber);
  }
  gid("submit").addEventListener("click", calcMoney);
  calcMoney();
}

function roth(currAge, retireAge, contribs, ror, catchup)
{
  var out = 0;
  for(var i = currAge; i < retireAge; i++)
  {
    out = (out + contribs + (i >= 50)*catchup) * (1 + ror);
  }
  return out;
}

function trad(currAge, retireAge, contribs, ror, currTax, retireTax, rorTaxSavings, catchup)
{
  var out = 0;
  for(var i = currAge; i < retireAge; i++)
  {
    out = (out + (contribs + (i >= 50)*catchup)*currTax) * (1 + rorTaxSavings*(1 - currTax));
  }
  return out + roth(currAge, retireAge, contribs, ror, catchup)*(1 - retireTax);
}

function calcMoney()
{
  var currAge = Number(gid("currAge").value);
  var retireAge = Number(gid("retireAge").value);
  var contribs = Number(gid("contribs").value);
  var currTax = Number(gid("currTax").value) / 100;
  var rorTaxSavings = Number(gid("rorTaxSavings").value) / 100;
  var catchup = Number(gid("catchup").value);
  for(var ror = 1; ror <= 20; ror++)
  {
    for(var rtax = 5; rtax <= 35; rtax++)
    {
      var x = gid("cell-" + rtax + "-" + ror);
      var rth = roth(currAge, retireAge, contribs, ror/100, catchup);
      var trd = trad(currAge, retireAge, contribs, ror/100, currTax, rtax/100, rorTaxSavings, catchup);
      var dif = (rth - trd)/1000;

      if(dif <= -1000) {x.className = "rdbu1";}
      else if(dif <= -250) {x.className = "rdbu2";}
      else if(dif <= -62.5) {x.className = "rdbu3";}
      else if(dif <= -15.625) {x.className = "rdbu4";}
      else if(dif < 15.625) {x.className = "rdbu5";}
      else if(dif < 62.5) {x.className = "rdbu6";}
      else if(dif < 250) {x.className = "rdbu7";}
      else if(dif < 1000) {x.className = "rdbu8";}
      else {x.className = "rdbu9"}
      x.title = "$" + (rth/1000000).toFixed(3) + "M - $" + (trd/1000000).toFixed(3) + "M";
      if(Math.abs(dif) < 1000)
      {
        x.innerHTML = "$" + dif.toFixed(0) + "k";
      } else
      {
        x.innerHTML = "$" + (dif/1000).toFixed(2) + "M";
      }
    }
  }
}
