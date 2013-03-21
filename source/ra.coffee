
RA = {
    # ----------------------------------------------------------------
    resolve: (doc, data, log_callback) ->
        # doc: a string
        # data: a hash/object
        # log: an optional logging function (will be passed a string to be logged)

        # split the doc up into parts

        parts = @_splitDoc doc
        result = []

        # based on each part's condition, decide whether to include it
        for part in parts
            if RA._conditionHolds part.condition, data, log_callback
                log_callback("true: [[" + part.condition + "]], content: " + part.content.split('\n')[0][0..20] + "...") if log_callback
                # the condition holds, so fill out the part and add it to the results
                result.push RA._fillOut(part.content, data)
            else
                # the condition doesn't hold, so don't add the part
                log_callback("NOT true: [[" + part.condition + "]], content: " + part.content.split('\n')[0][0..20] + "...") if log_callback

        # the final result is the join of all the included parts
        result.join ""
    # ----------------------------------------------------------------
    _splitDoc: (doc) ->
        # split the doc into parts

        # parts are separated by [[ condition ]]
        parts = []

        # the first split is on the [[, giving some number of rawparts
        openregex = ///
#            [^\S\n]*    # eat preceeding whitespace, except for newlines.  Maybe don't do this?
            \[\[        # eat two opening square brackets eg '[['
            \s*         # eat trailing whitespace (between opening brackets and the condition)
        ///
        rawparts = doc.split openregex
        for part in rawparts
            # the second split is on each individual rawpart, splitting on the
            # ]].  That gives two parts (the condition and the content).
            closeregex = ///
                \s*         # whitespace between condition and close brackets
                \]\]        # close brackets ]]
                [^\S\n]*    # following whitespace, apart from newlines
            ///
            bits = part.split closeregex
            if bits.length > 1
                parts.push {
                    condition: bits[0]
                    content: bits.slice(1).join(" ]] ") # put back any ]] other than the first
                }
            else
                # If there's no condition (which happens at the very start of the
                # doc) then we pretend there's a conditon of [[always]]
                parts.push {
                    condition: "always"
                    content: bits[0]
                }

        parts
    # ----------------------------------------------------------------
    _conditionHolds: (condition, data, log_callback) ->

        conditions =

            "never": () ->
                false

            "always": () ->
                true

            # left AND right
            "([\\s\\S]*)\\s+(and|AND)\\s+([\\s\\S]*)": (matches) ->
                left = RA._conditionHolds matches[1], data, log_callback
                right = RA._conditionHolds matches[3], data, log_callback
                (left and right)

            # left OR right
            "([\\s\\S]*)\\s+(or|OR)\\s+([\\s\\S]*)": (matches) ->
                left = RA._conditionHolds matches[1], data, log_callback
                right = RA._conditionHolds matches[3], data, log_callback
                (left or right)

            # left < right   ..less than
            # left > right   ..greater than
            # left = right   ..equal to
            # left == right  ..equal to
            # left != right  ..not equal to
            # left !== right ..not equal to
            # left <> right  ..not equal to
            # 1111      2222222222222222222      3333  ..match indices
            "(\\S+)\\s+(<=?|>=?|==?|!==?|<>)\\s+(\\S+)": (matches) ->
                left = RA._resolveTerm matches[1], data, log_callback
                right = RA._resolveTerm matches[3], data, log_callback

                switch matches[2]
                    when '<'
                        left < right
                    when '<='
                        left <= right
                    when '>'
                        left > right
                    when '>='
                        left >= right
                    when '=','=='
                        left == right
                    when '!=','!==','<>'
                        left != right

            # left <<5 right   ..at least 5 less than
            # left 10>> right   ..at least 10 greater than
            #           222222222222222222222            ..match indices
            # 1111       33  4444   5555  66       7777  ..match indices
            "(\\S+)\\s+((<<)(\\d+)|(\\d+)(>>))\\s+(\\S+)": (matches) ->
                left = RA._resolveTerm matches[1], data, log_callback
                right = RA._resolveTerm matches[7], data, log_callback

                if matches[3] == '<<' and matches[4]?
                    diff = RA._resolveTerm matches[4], log_callback
                    # TODO: fail out if left isn't numeric
                    (left + diff) <= right

        for pattern, evaluator of conditions
            regex = new RegExp pattern
            match_result = regex.exec condition
            if match_result?
                return evaluator match_result

        if log_callback
            log_callback "FAIL: Bad RA condition [[#{condition}]]"

        return false
    # ----------------------------------------------------------------
    _fillOut: (content, data) ->
        filledOut = content
        for varname, value of data
            # split/join to replace all instances :)
            filledOut = filledOut.split("\$\$" + varname).join(value)

        filledOut
    # ----------------------------------------------------------------
    _resolveTerm: (term, data, log_callback) ->

        if term[0..1] == "$$"
            # eat any initial dollardollar things
            term = term[2..]

        if term.indexOf("$$") isnt -1
            term = RA._fillOut term, data

        if data?.hasOwnProperty term
            value = data[term]
            if isNaN value
                value
            else
                parseFloat value

        else
            parseFloat term
    # ----------------------------------------------------------------
}

# stolen from Showdown...

# export
if typeof module != 'undefined'
    module.exports = RA;

# stolen from AMD branch of underscore
# AMD define happens at the end for compatibility with AMD loaders
# that don't enforce next-turn semantics on modules.
if typeof(define) == 'function' and define.amd
    define 'ra', () ->
        return RA
