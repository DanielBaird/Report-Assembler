// Generated by CoffeeScript 1.3.3
(function() {

  window.RA || (window.RA = {});

  RA.Controllers || (RA.Controllers = {});

  RA.DatasetController = Backbone.Controller.extend({
    routes: {
      '': 'index',
      'new': 'newDataset'
    },
    index: function() {
      var datasets;
      datasets = new RA.Collections.Datasets();
      datasets = {
        testSet1: {
          a: 12,
          b: 14
        },
        datasetTestTwo: {
          a: 102,
          b: 54,
          c: 22
        }
      };
      return new RA.DatasetList({
        datasets: datasets
      });
    }
  });

}).call(this);
