#!/usr/bin/env bash
# "$1": stock CSV "sku,name,stock,reorder_at". Print a Markdown report of the
# items with stock <= reorder_at: title, table (or a note), summary line.

# TODO 1: awk -F, ; skip header and blank lines, strip \r; a row whose two
#         numbers are not digits is reported as "skipped line N" on stderr.
# TODO 2: count valid rows; keep the low ones (store sku and the finished
#         table row in two parallel arrays).
# TODO 3: sort the low items by SKU yourself (insertion sort with "" forcing text).
# TODO 4: in END print the title, a blank line, the table or the italic note,
#         a blank line, and the "N of M item(s) need reordering." line.
#         Replace every | in names by \| .
