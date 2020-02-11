
function init()
{
  var inputs = document.getElementsByTagName("input");
  for(var i=0; i < inputs.length; i++)
  {
    inputs[i].addEventListener("change", updateTable);
  }
  gid("feature").addEventListener("change", updateTable);
  updateTable();
}

function updateTable()
{
  var trlist = gid("plant-tbody").getElementsByTagName("tr");
  anyshown = false;

  for(var r = 0; r < trlist.length; r++)
  {
    var trelt = trlist[r];
    var elt = plants[r];
    //if(trelt.id != elt.id) console.log("Warning: a mismatch occured.");

    var matchzone = false;
    for(var z = 1; z < 5; z++)
    {
      matchzone = matchzone || (gid("zone-" + z).checked && elt.Zone_list.includes(z));
    }

    var matchtype = false;
    for(var t = 1; t < 8; t++)
    {
      matchtype = matchtype || (gid("type-" + t).checked && elt.Type == plant_types[t-1]);
    }

    var matchsun = false;
    for(var s = 0; s < 11; s++)
    {
      matchsun = matchsun || (gid("sun-" + s).checked && elt.Sun_list.includes(s)) ||
        (gid("sun-unk").checked && elt.Sun_list.length == 0);
    }

    var matchmoist = false;
    for(var m = 0; m < 6; m++)
    {
      matchmoist = matchmoist || (gid("moisture-" + m).checked && elt.Moisture_list.includes(m)) ||
        (gid("moisture-unk").checked && elt.Moisture_list.length == 0);
    }

    var matchph = false;
    for(var p = 0; p < 7; p++)
    {
      matchph = matchph || (gid("ph-" + p).checked && elt.PH_list.includes(p)) ||
        (gid("ph-unk").checked && elt.PH_list.length == 0);
    }

    var matchfeat = gid("feature").value == "no filter" || elt.Feature_list.includes(gid("feature").value);

    var matchmn = false;
    for(var mn = 1; mn < 10; mn++)
    {
      matchmn = matchmn || (gid("mn-" + mn).checked && elt.MN_list.includes(mn)) ||
        (gid("mn-unk").checked && elt.MN_list.length == 0);
    }

    if(matchzone && matchtype && matchsun && matchmoist && matchph && matchfeat && matchmn)
    {
      anyshown = true;
      trelt.classList.remove("hidden");
    } else trelt.classList.add("hidden");
  }
  if(anyshown)
  {
    gid("nomatch").classList.add("hidden");
  } else gid("nomatch").classList.remove("hidden");
}
