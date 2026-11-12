# Common Mistakes

- **Using cat.** `cat names ips owners` stacks the files vertically: all names, then all addresses. You want `paste`.
- **Forgetting -d.** `paste a b` separates with a TAB, which looks like spaces in a terminal but is not a comma. Pass `-d,`.
- **Files that are not in the same order.** paste matches by line number only. If the address file is sorted and the names are not, the rows are wrong without any error.
- **Trailing blank lines.** An extra empty line at the end of one file adds a row such as `,,owner`. Check `wc -l` when the output has more rows than expected.
- **Confusing -s with the default.** `paste -s a b` makes one line per *file*, not per row. Use plain `paste` to build columns.
