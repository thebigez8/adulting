
function init()
{
  var tmp = ["diam1", "size1", "cost1", "diam2", "size2", "cost2"];
  for(var i = 0; i < tmp.length; i++)
  {
    document.getElementById(tmp[i]).addEventListener("change", calcMoney);
  }
  calcMoney();
}

function calcMoney()
{
  for(var i = 1; i < 3; i++)
  {
    var diam = Number(document.getElementById("diam"+i).value);
    var size = Number(document.getElementById("size"+i).value);
    var cost = Number(document.getElementById("cost"+i).value);
    var tmp = cost / (Math.PI * Math.pow(size / diam, 2));
    document.getElementById("ppsu"+i).innerHTML = '$' + tmp.toFixed(2);
  }
}
