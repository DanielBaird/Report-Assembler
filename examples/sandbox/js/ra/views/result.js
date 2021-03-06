// Generated by CoffeeScript 1.3.3
(function() {

  window.RA || (window.RA = {});

  RA.Views || (RA.Views = {});

  RA.Views.Result = Backbone.View.extend({
    tagName: 'div',
    className: 'result',
    initialize: function() {
      console.log("init-ing a RA.Views.Result");
      this.model.on('all', this.render, this);
      return this.mdConverter = new Showdown.converter();
    },
    render: function() {
      var data, doc, html, htmlResult, mdResult;
      data = this.model.get('data');
      doc = this.model.get('doc');
      if ((doc != null) && (data != null)) {
        mdResult = this.resolveResult();
        htmlResult = this.mdConverter.makeHtml(mdResult);
        console.log([mdResult, htmlResult]);
        html = "<div class=\"markdownresult\">\n	<h3>Resulting Report - Markdown</h3>\n	<pre>\n	" + mdResult + "\n	</pre>\n	</div>\n<div class=\"htmlresult\">\n	<h3>Resulting Report - HTML</h3>\n	<div class=\"html\">\n		" + htmlResult + "\n	</div>\n</div>";
      } else {
        if (doc != null) {
          html = "<span class=\"subtle\">choose a dataset.</span>";
        } else if (data != null) {
          html = "<span class=\"subtle\">choose a document.</span>";
        } else {
          html = "<span class=\"subtle\">choose a dataset and a document.</span>";
        }
      }
      this.$el.html(html);
      return this;
    },
    resolveResult: function() {
      var result;
      result = [];
      _.each(this.model.get('doc').get('parts'), function(part) {
        if (this.conditionHolds(part.condition)) {
          return result.push(this.fillOut(part.content));
        }
      }, this);
      return result.join("");
    },
    fillOut: function(content) {
      var filledOut, value, varname, _ref;
      filledOut = content;
      _ref = this.model.get('data').get('vars');
      for (varname in _ref) {
        value = _ref[varname];
        filledOut = filledOut.replace("\$\$" + varname, value);
      }
      return filledOut;
    },
    resolveTerm: function(term) {
      if (isNaN(term)) {
        return this.model.get('data').get('vars')[term];
      } else {
        return parseInt(term);
      }
    },
    conditionHolds: function(condition) {
      var conditions, evaluator, match_result, me, pattern, regex;
      me = this;
      conditions = {
        "never": function() {
          return false;
        },
        "always": function() {
          return true;
        },
        "(\\S+)\\s*(<|>|==?|!==?|<>)\\s*(\\S+)": function(matches) {
          var left, right;
          left = me.resolveTerm(matches[1]);
          right = me.resolveTerm(matches[3]);
          switch (matches[2]) {
            case '<':
              return left < right;
            case '>':
              return left > right;
            case '=':
            case '==':
              return left === right;
            case '!=':
            case '!==':
            case '<>':
              return left !== right;
          }
        }
      };
      if (condition == null) {
        return true;
      }
      for (pattern in conditions) {
        evaluator = conditions[pattern];
        regex = new RegExp(pattern);
        match_result = regex.exec(condition);
        if (match_result != null) {
          return evaluator(match_result);
        }
      }
    }
  });

}).call(this);
