
function init()
{
  var tmp = ["diam1", "size1", "cost1", "diam2", "size2", "cost2"];
  for(var i = 0; i < tmp.length; i++)
  {
    if(i != 0 && i != 3) gid(tmp[i]).addEventListener("change", validateNumber);
    gid(tmp[i]).addEventListener("change", calcMoney);
  }
  calcMoney();
}

function calcMoney()
{
  for(var i = 1; i < 3; i++)
  {
    var diam = Number(gid("diam"+i).value);
    var size = Number(gid("size"+i).value);
    var cost = Number(gid("cost"+i).value);
    var tmp = cost / (Math.PI * Math.pow(size / diam, 2));
    gid("ppsu"+i).innerHTML = '$' + tmp.toFixed(5);
  }
}
