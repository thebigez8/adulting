if(document.readyState === "complete")
{
  console.log("Document was ready");
  init();
} else
{
  document.addEventListener("DOMContentLoaded", init);
}
