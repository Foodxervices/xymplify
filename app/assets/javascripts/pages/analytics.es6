Foodxervices.analytics = {
  index: {
    init: function() {
      const data = $('#chartdiv').data('analytics')
      console.log(data)
      AmCharts.makeChart("chartdiv",
      {
        "type": "serial",
        "categoryField": "start_period",
        "startDuration": 1,
        "categoryAxis": {
          "gridPosition": "start"
        },
        "trendLines": [],
        "graphs": [
          {
            "balloonText": "[[title]]:[[value]]",
            "fillAlphas": 1,
            "id": "AmGraph-1",
            "title": "Current Quantity",
            "type": "column",
            "valueField": "current_quantity"
          },
          {
            "balloonText": "[[title]]:[[value]]",
            "fillAlphas": 1,
            "id": "AmGraph-2",
            "title": "Quantity Ordered",
            "type": "column",
            "valueField": "quantity_ordered"
          }
        ],
        "guides": [],
        "valueAxes": [
          {
            "stackType": "regular",
          }
        ],
        "allLabels": [],
        "balloon": {},
        "legend": {
          "enabled": true,
          "useGraphSettings": true
        },
        "dataProvider": data
      }
    );
    }
  }
}

  