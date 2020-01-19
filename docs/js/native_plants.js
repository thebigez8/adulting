
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
    var elt = trlist[r];
    var matchzone = false;
    for(var z = 1; z < 5; z++)
    {
      matchzone = matchzone || (gid("zone-" + z).checked && elt.dataset["zone" + z] == 1);
    }

    var matchtype = false;
    for(var t = 1; t < 8; t++)
    {
      matchtype = matchtype || (gid("type-" + t).checked && elt.dataset.type == t);
    }

    var matchsun = false;
    for(var s = 0; s < 11; s++)
    {
      matchsun = matchsun || (gid("sun-" + s).checked && elt.dataset["sun" + s] == 1) ||
        (gid("sun-unk").checked && elt.dataset["sun" + s] == 2);
    }

    var matchmoist = false;
    for(var m = 0; m < 6; m++)
    {
      matchmoist = matchmoist || (gid("moisture-" + m).checked && elt.dataset["moisture" + m] == 1) ||
        (gid("moisture-unk").checked && elt.dataset["moisture" + m] == 2);
    }

    var matchph = false;
    for(var p = 0; p < 7; p++)
    {
      matchph = matchph || (gid("ph-" + p).checked && elt.dataset["ph" + p] == 1) ||
        (gid("ph-unk").checked && elt.dataset["ph" + p] == 2);
    }

    var matchfeat = gid("feature").value == "no filter" || elt.dataset[gid("feature").value] == 1;
    console.log(elt.dataset);

    if(matchzone && matchtype && matchsun && matchmoist && matchph && matchfeat)
    {
      anyshown = true;
      elt.classList.remove("hidden");
    } else elt.classList.add("hidden");
  }
  if(anyshown)
  {
    gid("nomatch").classList.add("hidden");
  } else gid("nomatch").classList.remove("hidden");
}
