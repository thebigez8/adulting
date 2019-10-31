
function costs_of_scenarios(column)
{
  var ppdeduct = Number(gid("ppdeduct" + column).value);
  var famdeduct = Number(gid("famdeduct" + column).value);
  var ppoopm = Number(gid("ppoopm" + column).value);
  var famoopm = Number(gid("famoopm" + column).value);
  var coi = Number(gid("coi" + column).value) / 100;

  var copays = [
    gid("copay1" + column).value,
    gid("copay2" + column).value,
    gid("copay3" + column).value,
    gid("copay4" + column).value
  ];

  var out = [];
  for(var i = 0; i < 61; i++)
  {
    var tmp = i*500;
    var costs = [
      tmp,
      gid("cost2" + column).value,
      gid("cost3" + column).value,
      gid("cost4" + column).value
    ];
    out.push({input: tmp, cost: costs_of_plan(ppdeduct, famdeduct, ppoopm, famoopm, coi, costs, copays)});
  }

  return out;
}

function total_costs_of_scenarios(column, nm)
{
  var scenarios = costs_of_scenarios(column);
  var y = [];
  var x = [];
  for(var i = 0; i < scenarios.length; i++)
  {
    tmp = get_total_costs(
      scenarios[i].cost,
      Number(gid("premium" + column).value),
      Number(gid("fsahsa" + column).value),
      Number(gid("rollover" + column).value),
      Number(gid("currTax").value) / 100,
      Number(gid("rorHSA").value) / 100,
      Number(gid("freqContribs").value),
      column == 3
    );
    x.push(scenarios[i].input);
    y.push(tmp.total);
  }
  return {x: x, y: y, mode: "lines+markers", name: nm};
}

function make_plotly()
{
  var plan1 = total_costs_of_scenarios(1, "Traditional (lowest deductible)");
  var plan2 = total_costs_of_scenarios(2, "Traditional (higher deductible)");
  var plan3 = total_costs_of_scenarios(3, "High Deductible");

  var layout = {
    yaxis: {title: "Total Cost"},
    xaxis: {title: "Person 1 Medical Expenses"},
    showlegend: true,
    legend: {x: 0, y: 1.25}
  };

  Plotly.newPlot("vis", [plan1, plan2, plan3], layout);

}
