// Generated by CoffeeScript 1.3.3
(function() {

  window.RA || (window.RA = {});

  RA.Views || (RA.Views = {});

  RA.Views.DocumentList = Backbone.View.extend({
    tagName: 'div',
    className: 'documents',
    initialize: function() {
      return console.log("init-ing a RA.Views.DocumentList");
    },
    render: function() {
      var html;
      html = "<h2>Documents</h2>";
      this.$el.html(html);
      _.each(this.model.models, function(set) {
        return this.$el.append(new RA.Views.SingleDocument({
          model: set
        }).render().el);
      }, this);
      console.log('rendered DocumentList');
      return this;
    }
  });

  RA.Views.SingleDocument = Backbone.View.extend({
    tagName: 'div',
    className: 'singleDocument',
    initialize: function() {
      return console.log("init-ing a RA.Views.SingleDocument");
    },
    render: function() {
      var html, name;
      html = '';
      name = this.model.get('name');
      html += "<h3 class='name'>" + name + "</h3>";
      _.each(this.model.get('parts'), function(part) {
        return html += "" + part['condition'] + ": " + part['content'] + "<br>";
      });
      this.$el.append(html);
      return this;
    }
  });

}).call(this);
