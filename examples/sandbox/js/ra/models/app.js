// Generated by CoffeeScript 1.3.3
(function() {

  window.RA || (window.RA = {});

  RA.Models || (RA.Models = {});

  RA.Models.App = Backbone.Model.extend({
    initialize: function() {
      this.datasets = new RA.Collections.Datasets();
      this.documents = new RA.Collections.Documents();
      return this.result = new RA.Models.Result();
    },
    fetch: function() {
      this.datasets.fetch({
        success: function() {
          return console.log("got datasets");
        },
        error: function() {
          return alert("couldn't load datasets!");
        }
      });
      return this.documents.fetch({
        success: function() {
          return console.log("got documents");
        },
        error: function() {
          return alert("couldn't load documents!");
        }
      });
    }
  });

}).call(this);
