if(document.readyState === "complete")
{
  console.log("Document was ready");
  init();
} else
{
  document.addEventListener("DOMContentLoaded", init);
}

function init()
{
  document.getElementById("submit").addEventListener("click", calcMoney);
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
  var currAge = Number(document.getElementById("currAge").value);
  var retireAge = Number(document.getElementById("retireAge").value);
  var contribs = Number(document.getElementById("contribs").value);
  var currTax = Number(document.getElementById("currTax").value) / 100;
  var rorTaxSavings = Number(document.getElementById("rorTaxSavings").value) / 100;
  var catchup = Number(document.getElementById("catchup").value);
  for(var ror = 1; ror <= 20; ror++)
  {
    for(var rtax = 5; rtax <= 20; rtax++)
    {
      var x = document.getElementById("cell-" + ror + "-" + rtax);
      var tmp = roth(currAge, retireAge, contribs, ror/100, catchup) -
        trad(currAge, retireAge, contribs, ror/100, currTax, rtax/100, rorTaxSavings, catchup);
      tmp = Math.round(tmp/1000);

      if(tmp <= -501) {x.className = "rdbu1";}
      else if(tmp <= -358) {x.className = "rdbu2";}
      else if(tmp <= -215) {x.className = "rdbu3";}
      else if(tmp <= -72) {x.className = "rdbu4";}
      else if(tmp <= 71) {x.className = "rdbu5";}
      else if(tmp <= 214) {x.className = "rdbu6";}
      else if(tmp <= 357) {x.className = "rdbu7";}
      else if(tmp <= 500) {x.className = "rdbu8";}
      else {x.className = "rdbu9"}
      x.innerHTML = "$" + tmp + "k";
    }
  }
}
