Foodxervices.restaurants = {
  dashboard: {
    init: function() {
      new AlertListing('#alert-listing')
      this.initCostGraph()
    },
    initCostGraph: () => {
      google.charts.load('current', {packages: ['corechart']});
      google.charts.setOnLoadCallback(drawStacked);

      function drawStacked() {
        var data = google.visualization.arrayToDataTable([
          ['Month', 'Bolivia', 'Ecuador', 'Madagascar', 'Papua New Guinea', 'Rwanda', 'Average'],
          ['Feb',  165,      938,         522,             998,           450,      614.6],
          ['Mar',  135,      1120,        599,             1268,          288,      682],
          ['Apr',  157,      1167,        587,             807,           397,      623],
          ['May',  139,      1110,        615,             968,           215,      609.4],
          ['Jun',  136,      691,         629,             1026,          366,      569.6]
        ]);

        var options = {
          title : 'Your Cost/Revenue/Profit',
          height: 300,
          legend: { position: 'bottom', maxLines: 10 },
          bar: { groupWidth: '30%' },
          seriesType: 'bars',
          series: {5: {type: 'line'}},
          isStacked: true
        };

        var chart = new google.visualization.ComboChart(document.getElementById('cost-graph'));
        chart.draw(data, options);
      }
    }
  }
}