
function validateNumber()
{
  if(this.hasAttribute("max") && Number(this.max) < Number(this.value)) this.value = this.max;
  else if(this.hasAttribute("min") && Number(this.min) > Number(this.value)) this.value = this.min;
}

if(document.readyState === "complete")
{
  console.log("Document was ready");
  init();
} else
{
  document.addEventListener("DOMContentLoaded", init);
}
