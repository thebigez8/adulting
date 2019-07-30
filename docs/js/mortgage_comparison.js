
function init()
{
  var inputs = document.getElementsByTagName("input");
  for(var i=0; i < inputs.length; i++)
  {
    if(inputs[i].type == "number") inputs[i].addEventListener("change", validateNumber);
    inputs[i].addEventListener("change", calcMoney);
  }
  gid("mortgage").addEventListener("change", calcMoney);
  calcMoney();
}


function todays_dollars(monthly, infl, N)
{
  var tmp = 0;
  var out = [];
  for(var i = 0; i < N; i++)
  {
    tmp += monthly / Math.pow(infl, i);
    out.push(tmp);
  }
  return out;
}

function calcMoney()
{
  var N = Number(gid("mortgage").value);
  var p1 = Number(gid("loan1").value);
  var p2 = Number(gid("loan2").value);
  var r1 = Number(gid("rate1").value);
  var r2 = Number(gid("rate2").value);
  var fee1 = Number(gid("fee1").value);
  var fee2 = Number(gid("fee2").value);

  var infl = Number(gid("inflation").value);

  r1 = r1/12/100;
  r2 = r2/12/100;
  infl = Math.pow(1 + infl/100, 1/12);
  var monthly1 = p1*(r1 * Math.pow(1 + r1, N)) / (Math.pow(1 + r1, N) - 1);
  var monthly2 = p2*(r2 * Math.pow(1 + r2, N)) / (Math.pow(1 + r2, N) - 1);

  var pymts1 = todays_dollars(monthly1, infl, N);
  var pymts2 = todays_dollars(monthly2, infl, N);

  var loan2cheaper = (pymts1[0] + fee1 > pymts2[0] + fee2);

  var i = 0;
  for(; i < N; i++)
  {
    if( loan2cheaper && pymts1[i] + fee1 < pymts2[i] + fee2) break;
    if(!loan2cheaper && pymts1[i] + fee1 > pymts2[i] + fee2) break;
  }


  if(loan2cheaper && i == N)
  {
    gid("breakeven").innerHTML = "Loan 2 is always cheaper than loan 1.";
  } else if(loan2cheaper)
  {
    gid("breakeven").innerHTML = "Loan 2 is cheaper for the first " + i + " months.";
  } else if(i == N)
  {
    gid("breakeven").innerHTML = "Loan 1 is always cheaper than loan 2.";
  } else
  {
    gid("breakeven").innerHTML = "Loan 1 is cheaper for the first " + i + " months.";
  }

  gid("monthly1").innerHTML = '$' + monthly1.toFixed(2);
  gid("monthly2").innerHTML = '$' + monthly2.toFixed(2);

  gid("total1").innerHTML = '$' + pymts1[N-1].toFixed(2);
  gid("total2").innerHTML = '$' + pymts2[N-1].toFixed(2);

}
