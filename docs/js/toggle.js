
function toggle()
{
  this.classList.toggle("inactive");
  var y = document.getElementsByClassName("toggleable " + this.id.replace("-toggle", ""));
  for(var j = 0; j < y.length; j++)
  {
    if(this.classList.contains("inactive"))
    {
      y[j].classList.add("hidden");
    } else
    {
      y[j].classList.remove("hidden");
    }
  }
}

function linkTogglers()
{
  var x = document.getElementsByClassName("toggler");
  for(var i = 0; i < x.length; i++)
  {
    x[i].addEventListener("click", toggle);
  }
}
