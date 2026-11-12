# Debrief: The Cost Analyzer

Money in software is solved by one rule: never use floating point, count the smallest unit as an integer, and decide on paper where rounding happens. Your script chose ten-thousandths for prices because a price list needs that precision and cents for invoices because that is what a customer can pay. It rounded half up exactly once per line, so the invoice adds up as printed.

The graduated tier model is how cloud bills, income taxes and shipping rates work: each slice of the quantity is charged at its own rate, and a customer who crosses a boundary pays the higher rate only on the units beyond it. A common bug is the "cliff", charging all units at the new price; the boundary tests (100, 101, 1000, 1001) exist to catch it.

On the structure side, you built a typical reporting pipeline: parse and validate a reference file, aggregate transactions by a composite key, then render in a stable order. Validation was loud (a broken price list exits 2) while bad data rows were skipped and reported, because one typo in a month of usage should not block the invoices of everyone else, but it must be impossible to miss.

Associative arrays with composite keys, `printf` for fixed columns and half-up integer rounding are tools you will reuse in every report script.

Going further: invoices are about what people own up to. The next mission looks for what they forgot: a scanner for weak permissions and risky configuration.
