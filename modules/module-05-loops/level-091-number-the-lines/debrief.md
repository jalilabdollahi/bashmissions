# Debrief: Number the Lines

Sometimes the item is not enough: you also need to know its position. A loop over indexes gives you both, because the position is the loop variable and the item is looked up from it.

## How it works
Bash arrays are zero-based. `${arr[i]}` is the element at position `i`, `${#arr[@]}` is how many elements there are, and `${!arr[@]}` lists the valid indexes (useful for sparse arrays). Inside the brackets Bash evaluates arithmetic, so `${days[i % 7]}` is legal and needs no `$(( ))`.

The `%` operator is how counters become cycles. Day of week, rotating through a pool of servers, round-robin assignment, colours alternating in a table: they are all "position modulo size".

Copying the arguments into an array with `people=("$@")` is a common first step when you need random access to them. Remember to quote it, or names with spaces split into several elements.

Index-based loops also make it easy to look at neighbours (`${arr[i+1]}`), compare with the previous item, or number your output starting at 1 by printing `i + 1`.

## In real work
Assigning tasks to engineers round-robin, spreading backups across hosts, numbering a report, pairing two lists that share positions.

## Going further
Input does not always arrive as a clean list. Level 92 keeps asking until the user gives a valid answer.
