RA = require '../bin/ra'

describe "Report Assembler exists", ->

    it "should be in the global namespace", ->
        expect( RA ).toBeDefined()

    it "should have a resolve function", ->
        expect( typeof RA.resolve ).toBe "function"


describe "Report Assembler basics", ->

    it "should pass through an empty document", ->
        expect( RA.resolve("", {}) ).toBe ""

    it "should pass through a non-conditional documents", ->
        expect( RA.resolve("abc", {}) ).toBe "abc"
        expect( RA.resolve("\n", {}) ).toBe "\n"
        expect( RA.resolve("a\nb\nc\n", {}) ).toBe "a\nb\nc\n"
        expect( RA.resolve("a\n\nb", {}) ).toBe "a\n\nb"

    it "should replace double-dollar variables", ->
        expect( RA.resolve("$$a", {a: 1}) ).toBe "1"























