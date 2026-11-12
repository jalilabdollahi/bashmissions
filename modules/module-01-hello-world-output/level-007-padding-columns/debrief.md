# Debrief: Padding Columns

Alignment is a property of the template, not of the data. You decide once how wide a column is, and every value that passes through gets the same treatment.

## How it works
In `%-10s` the pieces mean: `%` starts a placeholder, `-` asks for left alignment, `10` is the minimum width, `s` is the type. If the value is shorter, printf adds spaces; if it is longer, printf prints it in full and the column stretches rather than losing data.

Numbers default to right alignment because the digits then line up by place value: units under units. Text defaults to right as well, which is why you add the minus for names.

## In real work
Anything meant for human eyes and fixed-width fonts benefits: process lists, invoices, disk reports, the kind of table Gus pins on the fridge.

## Going further
So far every printf line ended with a newline. Level 8 shows how to deliberately leave it off.
