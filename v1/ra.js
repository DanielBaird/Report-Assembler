// Generated by CoffeeScript 1.3.3
(function() {
  var RA;

  $(function() {
    var doc;
    doc = {
      vars: {
        a: 101,
        b: 4
      },
      sections: {
        intro: {
          title: 'Introduction',
          vars: {
            b: 12
          },
          texts: [
            {
              content: 'A and B are always interesting.'
            }, {
              condition: 'never',
              content: "If you are reading this, contact Jeremy for a free drink."
            }, {
              condition: 'a == b',
              content: 'In this case, A and B are both $$a.'
            }, {
              condition: 'a != b',
              content: 'In this case, A is $$a.'
            }, {
              condition: 'a > b',
              content: 'That is larger than B, which is $$b.'
            }, {
              condition: 'a < b',
              content: 'That is smaller than B, which is $$b.'
            }, {
              condition: 'a < 100',
              content: "At least A is below 100.  Lucky, coz if A gets past 100 everyone catches on fire."
            }
          ]
        },
        alerts: {
          title: 'Important Warnings',
          texts: [
            {
              condition: 'a > 99',
              content: "Get out of there! When A gets past 100, everyone catches on fire!"
            }
          ]
        }
      }
    };
    return RA.produce(doc);
  });

  RA = window.RA = {};

  RA.resolve_term = function(term, vars) {
    if (isNaN(term)) {
      return vars[term];
    } else {
      return parseInt(term);
    }
  };

  RA.holds = function(condition, vars) {
    var conditions, evaluator, match_result, pattern, regex;
    conditions = {
      "never": function() {
        return false;
      },
      "always": function() {
        return true;
      },
      "(\\S+)\\s*(<|>|==?|!==?|<>)\\s*(\\S+)": function(matches, vars) {
        var left, right;
        left = RA.resolve_term(matches[1], vars);
        right = RA.resolve_term(matches[3], vars);
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
    if (condition === void 0) {
      return true;
    }
    for (pattern in conditions) {
      evaluator = conditions[pattern];
      regex = new RegExp(pattern);
      match_result = regex.exec(condition);
      if (match_result !== null) {
        return evaluator(match_result, vars);
      }
    }
  };

  RA.fillout = function(content, vars) {
    var value, varname;
    for (varname in vars) {
      value = vars[varname];
      content = content.replace("\$\$" + varname, value);
    }
    return content;
  };

  RA.do_section = function(name, section, globals) {
    var is_blank, merged_vars, text, _i, _len, _ref, _results;
    is_blank = true;
    merged_vars = $.extend({}, globals, section.vars);
    _ref = section.texts;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      text = _ref[_i];
      if (RA.holds(text.condition, merged_vars)) {
        if (is_blank && (section.title != null)) {
          $('body').append("<h2>" + section.title + "</h2>");
        }
        is_blank = false;
        $('body').append(RA.fillout(text.content, merged_vars));
        _results.push($('body').append(" "));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  RA.produce = function(doc) {
    var name, section, _ref, _results;
    _ref = doc.sections;
    _results = [];
    for (name in _ref) {
      section = _ref[name];
      _results.push(RA.do_section(name, section, doc.vars));
    }
    return _results;
  };

}).call(this);
