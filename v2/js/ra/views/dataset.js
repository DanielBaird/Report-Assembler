// Generated by CoffeeScript 1.3.3
(function() {

  window.RA || (window.RA = {});

  RA.Views || (RA.Views = {});

  RA.Views.DatasetList = Backbone.View.extend({
    tagName: 'div',
    className: 'datasets',
    events: {
      "click #newdataset": "addNew"
    },
    initialize: function() {
      console.log("init-ing a RA.Views.DatasetList");
      this.model.on('add', this.render, this);
      return this.model.on('remove', this.render, this);
    },
    render: function() {
      var html;
      html = "<h2>Datasets</h2>\n<button id=\"newdataset\">new</button>";
      this.$el.html(html);
      _.each(this.model.models, function(set) {
        return this.$el.append(new RA.Views.SingleDataset({
          model: set
        }).render().el);
      }, this);
      console.log('rendered DatasetList');
      return this;
    },
    addNew: function() {
      return this.model.create({
        editing: true
      });
    }
  });

  RA.Views.SingleDataset = Backbone.View.extend({
    tagName: 'div',
    className: 'singleDataset',
    events: {
      "click .edit": "startEdit",
      "click .save": "saveEdit",
      "click .cancel": "cancelEdit",
      "click .maybedelete": "showDelete",
      "click .dontdelete": "hideDelete",
      "click .delete": "delete"
    },
    initialize: function() {
      console.log("init-ing a RA.Views.SingleDataset");
      return this.model.on('change', this.render, this);
    },
    render: function() {
      var html, name, varslist;
      name = this.model.get('name');
      html = "<button class=\"edit\">edit</button>\n<button class=\"maybedelete\">delete</button>\n<button class=\"dontdelete\">not really</button>\n<button class=\"delete\">really delete?</button>\n<h3 class=\"name\">" + name + "</h3>";
      if (this.model.get('editing')) {
        html = "<button class=\"save\">save</button>\n<button class=\"cancel\">cancel</button>\n<input type=\"text\" value=\"" + name + "\" />";
      }
      this.$el.html(html);
      varslist = $('<pre></pre>');
      if (this.model.get('editing')) {
        varslist = $("<textarea>\n</textarea>");
      }
      this.$el.append(varslist);
      _.each(this.model.get('vars'), function(varvalue, varname) {
        return varslist.append("" + varname + ": " + varvalue + "\n");
      });
      this.$el.toggleClass('editing', this.model.get('editing'));
      return this;
    },
    startEdit: function() {
      this.$el.addClass('editing');
      return this.model.set('editing', true);
    },
    cancelEdit: function() {
      return this.model.set('editing', false);
    },
    saveEdit: function() {
      var lines, newvars;
      newvars = {};
      lines = this.$('textarea').val().split("\n");
      _.each(lines, function(line) {
        var bits;
        bits = line.split(/\s*:\s*/);
        if (bits.length === 2) {
          return newvars[bits[0]] = bits[1];
        }
      });
      this.model.set({
        vars: newvars,
        name: this.$('input').val(),
        editing: false
      });
      return this.model.save();
    },
    showDelete: function() {
      this.$('.maybedelete').hide();
      this.$('.dontdelete').show();
      return this.$('.delete').show();
    },
    hideDelete: function() {
      this.$('.dontdelete').hide();
      this.$('.delete').hide();
      return this.$('.maybedelete').show();
    },
    "delete": function() {
      return this.model.destroy();
    }
  });

}).call(this);
