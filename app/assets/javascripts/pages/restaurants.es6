Foodxervices.restaurants = {
  dashboard: {
    init: function() {
      new AlertListing('#alert-listing')

      setTimeout(() => {
        this.initCostGraph()  
      }, 200)
    },
    initCostGraph: function() {
      google.charts.load('current', {packages: ['corechart', 'controls']});
      google.charts.setOnLoadCallback(this.drawStacked);
    },
    drawStacked: () => {
      var data = getData()

      if(data.length < 2) {
        data = [
          ['', ' ', { role: 'annotation' }],
          ['', 0, "The data doesn't exist yet"]
        ]
        $('#graph-filter').hide()
      }

      var dataTable = google.visualization.arrayToDataTable(data);
      var currencySymbol = $('#cost-graph').data('currency-symbol')
      var graphWidth = dataTable.getNumberOfRows() * 90
      var options = {
        title : `Your Costs`,
        titleTextStyle: { fontSize: 30 },
        width: graphWidth > 900 ? graphWidth : 900,
        height: 500,
        seriesType: 'bars',
        isStacked: true,
        vAxis: {
          format: `${currencySymbol}#`,
          minValue: 0.1,
          textStyle : { 
            fontSize: 14 
          }
        },
        hAxis : { 
          textStyle : { 
            fontSize: 14 
          }
        },
        tooltip: {
          textStyle: { 
            fontSize: 14 
          }
        },
        legend:{
          textStyle:{
            fontSize: 14
          },
          position: 'bottom'
        },
        bar: {
          groupWidth: 50
        },
        chartArea: {left:'40', right: '15'},
        // series: {5: {type: 'line'}},
      };

      var columnsTable = new google.visualization.DataTable();
      columnsTable.addColumn('number', 'colIndex');
      columnsTable.addColumn('string', 'colLabel');
      var initState= {selectedValues: []};
      
      for (var i = 1; i < dataTable.getNumberOfColumns(); i++) {
          columnsTable.addRow([i, dataTable.getColumnLabel(i)]);
          initState.selectedValues.push(dataTable.getColumnLabel(i));
      }

      var chart = new google.visualization.ChartWrapper({
        'chartType': 'ComboChart',
        'containerId': 'cost-graph',
        'dataTable': dataTable,
        'options': options
      })
      chart.draw();

      var filter = new google.visualization.ControlWrapper({
        controlType: 'CategoryFilter',
        containerId: 'graph-filter',
        dataTable: columnsTable,
        options: {
            filterColumnLabel: 'colLabel',
            ui: {
                label: 'Item',
                allowTyping: false,
                allowMultiple: true,
                allowNone: false,
                labelStacking: 'vertical'
            }
        },
        state: initState
      });

      google.visualization.events.addListener(filter, 'statechange', setChartView);
      
      setChartView();
      filter.draw();
      
      function getData() {
        var monthArray = []
        var data = $('#cost-graph').data('graph')
        var res = [[]]
        var currencySymbol = $('#cost-graph').data('currency-symbol')

        $.each(data, function(month, monthData) {
          $.each(monthData, function(tag, total_price) {
            res[0].push(tag)
          })
        })

        res[0] = $.unique(res[0])

        $.each(data, function(month, monthData) {
          month = new Date(month).toLocaleString('en-us', { month: "short", year: "numeric" })
          monthArray = [month]

          $.each(res[0], function(i, headTag) {
            var price = null

            $.each(monthData, function(tag, total_price) {
              if(headTag == tag) {
                price = total_price
                return false 
              }
            })

            monthArray.push({ v: price, f: `${currencySymbol}${price}` })
          })
          res.push(monthArray)
        })

        res[0].unshift('Month')
        
        return res
      }

      function setChartView () {
        var state = filter.getState();
        var row;
        var view = {
          columns: [0]
        };
        for (var i = 0; i < state.selectedValues.length; i++) {
            row = columnsTable.getFilteredRows([{column: 1, value: state.selectedValues[i]}])[0];
            view.columns.push(columnsTable.getValue(row, 0));
        }
    
        view.columns.sort(function (a, b) {
            return (a - b);
        });
        chart.setView(view);
        chart.draw();
      }
    }
  }
}