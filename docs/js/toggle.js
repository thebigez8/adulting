
function toggle(source)
{
  function out()
  {
    source.classList.toggle("inactive");
    var y = document.getElementsByClassName("toggleable " + source.dataset.target);
    for(var j = 0; j < y.length; j++)
    {
      if(source.classList.contains("inactive"))
      {
        y[j].classList.add("hidden");
      } else
      {
        y[j].classList.remove("hidden");
      }
    }
  }
  return out;
}

function linkTogglers()
{
  var x = document.getElementsByClassName("toggler");
  for(var i = 0; i < x.length; i++)
  {
    if(x[i].tagName == "BUTTON")
    {
      x[i].addEventListener("click", toggle(x[i]));
    } else
    {
      x[i].addEventListener("change", toggle(x[i]));
    }
  }
}
