// Generated by CoffeeScript 1.6.2
(function() {
  var RA;

  RA = {
    resolve: function(doc, data, log_callback) {
      var part, parts, result, _i, _len;

      parts = this._splitDoc(doc);
      result = [];
      for (_i = 0, _len = parts.length; _i < _len; _i++) {
        part = parts[_i];
        if (RA._conditionHolds(part.condition, data, log_callback)) {
          if (log_callback) {
            log_callback("true: [[" + part.condition + "]], content: " + part.content.split('\n')[0].slice(0, 21) + "...");
          }
          result.push(RA._fillOut(part.content, data));
        } else {
          if (log_callback) {
            log_callback("NOT true: [[" + part.condition + "]], content: " + part.content.split('\n')[0].slice(0, 21) + "...");
          }
        }
      }
      return result.join("");
    },
    _splitDoc: function(doc) {
      var bits, closeregex, openregex, part, parts, rawparts, _i, _len;

      parts = [];
      openregex = /\[\[\s*/;
      rawparts = doc.split(openregex);
      for (_i = 0, _len = rawparts.length; _i < _len; _i++) {
        part = rawparts[_i];
        closeregex = /\s*\]\][^\S\n]*/;
        bits = part.split(closeregex);
        if (bits.length > 1) {
          parts.push({
            condition: bits[0],
            content: bits.slice(1).join(" ]] ")
          });
        } else {
          parts.push({
            condition: "always",
            content: bits[0]
          });
        }
      }
      return parts;
    },
    _conditionHolds: function(condition, data, log_callback) {
      var conditions, evaluator, match_result, pattern, regex;

      conditions = {
        "never": function() {
          return false;
        },
        "always": function() {
          return true;
        },
        "([\\s\\S]*)\\s+(and|AND)\\s+([\\s\\S]*)": function(matches) {
          var left, right;

          left = RA._conditionHolds(matches[1], data, log_callback);
          right = RA._conditionHolds(matches[3], data, log_callback);
          return left && right;
        },
        "([\\s\\S]*)\\s+(or|OR)\\s+([\\s\\S]*)": function(matches) {
          var left, right;

          left = RA._conditionHolds(matches[1], data, log_callback);
          right = RA._conditionHolds(matches[3], data, log_callback);
          return left || right;
        },
        "(\\S+)\\s+(<=?|>=?|==?|!==?|<>)\\s+(\\S+)": function(matches) {
          var left, right;

          left = RA._resolveTerm(matches[1], data, log_callback);
          right = RA._resolveTerm(matches[3], data, log_callback);
          switch (matches[2]) {
            case '<':
              return left < right;
            case '<=':
              return left <= right;
            case '>':
              return left > right;
            case '>=':
              return left >= right;
            case '=':
            case '==':
              return left === right;
            case '!=':
            case '!==':
            case '<>':
              return left !== right;
          }
        },
        "(\\S+)\\s+((<<)(\\d+)|(\\d+)(>>))\\s+(\\S+)": function(matches) {
          var diff, left, right;

          left = RA._resolveTerm(matches[1], data, log_callback);
          right = RA._resolveTerm(matches[7], data, log_callback);
          if (matches[3] === '<<' && (matches[4] != null)) {
            diff = RA._resolveTerm(matches[4], log_callback);
            return (left + diff) <= right;
          }
        }
      };
      for (pattern in conditions) {
        evaluator = conditions[pattern];
        regex = new RegExp(pattern);
        match_result = regex.exec(condition);
        if (match_result != null) {
          return evaluator(match_result);
        }
      }
      if (log_callback) {
        log_callback("FAIL: Bad RA condition [[" + condition + "]]");
      }
      return false;
    },
    _fillOut: function(content, data) {
      var filledOut, value, varname;

      filledOut = content;
      for (varname in data) {
        value = data[varname];
        filledOut = filledOut.split("\$\$" + varname).join(value);
      }
      return filledOut;
    },
    _resolveTerm: function(term, data, log_callback) {
      var value;

      if (term.slice(0, 2) === "$$") {
        term = term.slice(2);
      }
      if (term.indexOf("$$") !== -1) {
        term = RA._fillOut(term, data);
      }
      if (data != null ? data.hasOwnProperty(term) : void 0) {
        value = data[term];
        if (isNaN(value)) {
          return value;
        } else {
          return parseFloat(value);
        }
      } else {
        return parseFloat(term);
      }
    }
  };

  if (typeof module !== 'undefined') {
    module.exports = RA;
  }

  if (typeof define === 'function' && define.amd) {
    define('ra', function() {
      return RA;
    });
  }

}).call(this);
