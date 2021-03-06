Report Assembler makes it easy to dynamically generate a textual report
from data.  You can **insert** data values into the report text, and you
can change what gets included in the report using **conditions**.

For example, if you have data like this:

    ZombieSpeedMPH: 4.5
    IncubationPeriodDays: 2

Then you can write a report template like this:

    Your local zombie variety moves at $$ZombieSpeedMPH mph.  If you get
    bitten, you will turn into a zombie after $$IncubationPeriodDays
    [[IncubationPeriodDays != 1]]days.[[IncubationPeriodDays == 1]]day.

Report Assembler takes your report template, works out the conditions 
and insertions, and gives you the completed report.

Insertions
----------
Insertions start with two dollar signs, like this: `$$DatumName`.  The 
dollar signs and the name after it will be replaced by the actual value 
of the data.

Conditions
----------
Conditions are wrapped in double square brackets, like this: 
`[[ZombieDeadliness > PirateDeadliness]]`.  Anything after a conditon 
will only be included in the final report if the conditon is true.

These are RA's conditions:

* `always` is always true
* `never` is never true
* `a == b` is true if `a` and `b` are equal
* `a != b` is true if `a` and `b` are not equal
* `a > b` is true if `a` is greater than `b`
* `a >= b` is true if `a` is greater than `b` or equal to `b`
* `a < b` is true if `a` is less than `b`
* `a <= b` is true if `a` is less than `b` or equal to `b`

Coming soon:

* `a <10< b` is true if a is less than `b` by 10 or more
