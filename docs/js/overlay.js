
function showOverlay(source)
{
  function out()
  {
    document.body.classList.add("scroller-none");
    var y = document.getElementById(source.dataset.target);
    y.classList.remove("hidden");
  }
  return out;
}

function closeOverlay(source)
{
  function out()
  {
    source.classList.add("hidden");
    document.body.classList.remove("scroller-none");
  }
  return out;
}

function linkOverlays()
{
  var x = document.getElementsByClassName("overlay-toggler");
  for(var i = 0; i < x.length; i++)
  {
    x[i].addEventListener("click", showOverlay(x[i]));
  }
  var y = document.getElementsByClassName("overlay");
  for(var j = 0; j < y.length; j++)
  {
    y[j].addEventListener("click", closeOverlay(y[j]));
  }
}
