RA = require '../bin/ra'

# -------------------------------------------------------------------
describe 'Report Assembler object', ->

    it 'should be in the global namespace', ->
        expect( RA ).toBeDefined()

    it 'should have a resolve function', ->
        expect( typeof RA.resolve ).toEqual 'function'

# -------------------------------------------------------------------
describe 'Report Assembler resolver', ->

    it 'should pass through an empty document', ->
        expect( RA.resolve('', {}) ).toEqual ''

# -------------------------------------------------------------------
describe 'Report Assembler replacements', ->

    it 'should replace double-dollar variables', ->
        expect( RA.resolve('$$a', {a: 1}) ).toEqual '1'
        expect( RA.resolve('$$a', {a: '1'}) ).toEqual '1'
        expect( RA.resolve('$$a', {a: 'ra'}) ).toEqual 'ra'
        expect( RA.resolve('$$abc', {abc: 'ra'}) ).toEqual 'ra'

    it 'should NOT replace unrecognised variables', ->
        expect( RA.resolve('$$a', {}) ).toEqual '$$a'
        expect( RA.resolve('$$a', {b: 1}) ).toEqual '$$a'

# -------------------------------------------------------------------
describe 'Report Assembler always and never conditions', ->

    it 'should pass through empty documents', ->
        expect( RA.resolve('', {}) ).toEqual ''

    it 'should pass through non-conditional documents', ->
        expect( RA.resolve('abc', {}) ).toEqual 'abc'

    it 'should pass through non-conditional documents with newlines', ->
        expect( RA.resolve("\n", {}) ).toEqual "\n"
        expect( RA.resolve("a\nb\nc\n", {}) ).toEqual "a\nb\nc\n"
        expect( RA.resolve("a\n\nb", {}) ).toEqual "a\n\nb"

    it 'should include [[always]] conditions', ->
        expect( RA.resolve('[[always]]abc', {}) ).toEqual 'abc'
        expect( RA.resolve('abc[[always]]def', {}) ).toEqual 'abcdef'
        expect( RA.resolve("abc[[always]]\ndef", {}) ).toEqual "abc\ndef"

    it 'should NOT include [[never]] conditions', ->
        expect( RA.resolve('[[never]]abc', {}) ).toEqual ''
        expect( RA.resolve('abc[[never]]def', {}) ).toEqual 'abc'
        expect( RA.resolve("abc[[never]]\ndef", {}) ).toEqual 'abc'

# -------------------------------------------------------------------
describe 'Report Assembler multiple conditions', ->

    it 'should handle multiple conditions', ->
        expect( RA.resolve('abc[[never]]def[[always]]ghi', {}) ).toEqual 'abcghi'

# -------------------------------------------------------------------
describe 'Report Assembler variable resolution conditions', ->

    data = null

    beforeEach ->
        data = { a1: 'aaa', a2: 'aaa', b1: 'bbb', n: 'name', longname: 'aaa' }

    it 'should use bare-name variables in conditions', ->
        expect( RA.resolve('[[a1 == a2]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[a1 == b1]]abc', data) ).toEqual ''

    it 'should use dollardollar-name variables in conditons', ->
        expect( RA.resolve('[[$$a1 == $$a2]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[$$a1 == $$b1]]abc', data) ).toEqual ''

    it 'should replace dollardollar-name variables inside other variables in conditions', ->
        expect( RA.resolve('[[long$$n == $$a2]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[long$$n == $$b1]]abc', data) ).toEqual ''
        expect( RA.resolve('[[$$long$$n == $$a2]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[$$long$$n == $$b1]]abc', data) ).toEqual ''

# -------------------------------------------------------------------
describe 'Report Assembler string comparator conditions', ->

    data = null

    beforeEach ->
        data = { a1: 'aaa', a2: 'aaa', b1: 'bbb' }

    it 'should equality-compare string variables', ->
        expect( RA.resolve('[[a1 == a2]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[a1 == b1]]abc', data) ).toEqual ''
        expect( RA.resolve('[[a1 != a2]]abc', data) ).toEqual ''
        expect( RA.resolve('[[a1 != b1]]abc', data) ).toEqual 'abc'

# -------------------------------------------------------------------
describe 'Report Assembler integer comparator conditions', ->

    data = null

    beforeEach ->
        data = { one: 1, two: 2, ten: 10, tenagain: 10 }

    it 'should equality-compare numeric variables', ->
        expect( RA.resolve('[[one == one]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[one == two]]abc', data) ).toEqual ''
        expect( RA.resolve('[[one != one]]abc', data) ).toEqual ''
        expect( RA.resolve('[[one != two]]abc', data) ).toEqual 'abc'

    it 'should compare numeric variables using greater-than', ->
        expect( RA.resolve('[[one > one]]abc', data) ).toEqual ''
        expect( RA.resolve('[[one > two]]abc', data) ).toEqual ''
        expect( RA.resolve('[[ten > two]]abc', data) ).toEqual 'abc'

    xit 'should compare numeric variables using greater-than-or-equal-to', ->
        expect( RA.resolve('[[one >= one]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[one >= two]]abc', data) ).toEqual ''
        expect( RA.resolve('[[ten >= two]]abc', data) ).toEqual 'abc'

    it 'should compare numeric variables using less-than', ->
        expect( RA.resolve('[[one < one]]abc', data) ).toEqual ''
        expect( RA.resolve('[[one < two]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[ten < two]]abc', data) ).toEqual ''

    xit 'should compare numeric variables using less-than-or-equal-to', ->
        expect( RA.resolve('[[one <= one]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[one <= two]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[ten <= two]]abc', data) ).toEqual ''


# -------------------------------------------------------------------
describe 'Report Assembler integer-looking-strings comparator conditions', ->

    data = null

    beforeEach ->
        data = { one: '1', two: '2', ten: '10', tenagain: '10' }

    it 'should equality-compare numeric-looking string variables', ->
        expect( RA.resolve('[[one == one]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[one == two]]abc', data) ).toEqual ''
        expect( RA.resolve('[[one != one]]abc', data) ).toEqual ''
        expect( RA.resolve('[[one != two]]abc', data) ).toEqual 'abc'

    it 'should compare numeric-looking string variables using greater-than', ->
        expect( RA.resolve('[[one > one]]abc', data) ).toEqual ''
        expect( RA.resolve('[[one > two]]abc', data) ).toEqual ''
        expect( RA.resolve('[[ten > two]]abc', data) ).toEqual 'abc'

    xit 'should compare numeric-looking string variables using greater-than-or-equal-to', ->
        expect( RA.resolve('[[one >= one]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[one >= two]]abc', data) ).toEqual ''
        expect( RA.resolve('[[ten >= two]]abc', data) ).toEqual 'abc'

    it 'should compare numeric-looking string variables using less-than', ->
        expect( RA.resolve('[[one < one]]abc', data) ).toEqual ''
        expect( RA.resolve('[[one < two]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[ten < two]]abc', data) ).toEqual ''

    xit 'should compare numeric-looking string variables using less-than-or-equal-to', ->
        expect( RA.resolve('[[one <= one]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[one <= two]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[ten <= two]]abc', data) ).toEqual ''

# -------------------------------------------------------------------
describe 'Report Assembler floating-point comparator conditions', ->

    data = null

    beforeEach ->
        data = { oneish: 1.01, littlelarger: 1.02, twoish: 2.01, tenish: 9.99 }

    it 'should equality-compare floating-point variables', ->
        expect( RA.resolve('[[oneish == oneish]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[oneish == littlelarger]]abc', data) ).toEqual ''
        expect( RA.resolve('[[oneish != oneish]]abc', data) ).toEqual ''
        expect( RA.resolve('[[oneish != littlelarger]]abc', data) ).toEqual 'abc'

    it 'should compare floating-point variables using greater-than', ->
        expect( RA.resolve('[[oneish > oneish]]abc', data) ).toEqual ''
        expect( RA.resolve('[[oneish > littlelarger]]abc', data) ).toEqual ''
        expect( RA.resolve('[[tenish > twoish]]abc', data) ).toEqual 'abc'

    xit 'should compare floating-point variables using greater-than-or-equal-to', ->
        expect( RA.resolve('[[oneish >= oneish]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[oneish >= littlelarger]]abc', data) ).toEqual ''
        expect( RA.resolve('[[tenish >= twoish]]abc', data) ).toEqual 'abc'

    it 'should compare floating-point variables using less-than', ->
        expect( RA.resolve('[[oneish < oneish]]abc', data) ).toEqual ''
        expect( RA.resolve('[[oneish < littlelarger]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[tenish < twoish]]abc', data) ).toEqual ''

    xit 'should compare floating-point variables using less-than-or-equal-to', ->
        expect( RA.resolve('[[oneish <= oneish]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[oneish <= littlelarger]]abc', data) ).toEqual 'abc'
        expect( RA.resolve('[[tenish <= twoish]]abc', data) ).toEqual ''





















