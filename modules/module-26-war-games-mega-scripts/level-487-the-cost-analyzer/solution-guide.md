# Walkthrough: The Cost Analyzer

## The plan
Billing code has one rule above all others: the same inputs must always produce the same cents. That rules out floating point and "whatever rounding the spreadsheet did". Instead we fix the unit (ten-thousandths of a dollar for prices, cents for everything on the invoice), the rounding rule (half up, once per item line), and the order of the adjustments (discount, then minimum charge, then tax on what remains). Then the program is three layers: parse the price list, aggregate the usage, print the invoices.

## Step by step

1. **Parse prices into integers.** `0.0125` becomes `125` by splitting at the decimal point with a regex, padding the fraction to four digits and combining `whole*10000 + frac`. A price line is `ITEM UNIT TIER...` where tiers must have strictly increasing limits and end with `*`. Validate while parsing, so a broken price list stops the run before it can produce a wrong invoice.

2. **Graduated tiers.** Think of the quantity as a pile of units filling tiers from the bottom. The first tier takes up to its limit, the next takes what fits up to its own limit, and so on. In code: for each tier compute `top = min(qty, upto)`, charge `(top - prev) * price`, and set `prev = upto`. Exactly 100 GB fills tier one and nothing more; 101 GB charges one unit at the second price, which the "tier boundary" test checks.

3. **Aggregate the CSV.** `IFS=, read -r cust item q extra` splits each row. Rows for the same pair add up in `qty[$cust|$item]`. Bad rows are reported by physical line number (including the header, which is skipped when it is line 1) and counted so the exit status can be 1.

4. **Round once.** Each item line becomes cents by `(x + 50) / 100`. Adding up already rounded lines is what a customer can verify on paper. Rounding only at the end would produce totals that do not equal the sum of the visible lines, which is the first thing an accountant checks.

5. **Adjust in a fixed order.** Discount on the subtotal, then raise to the minimum charge if needed, then tax on the result. The order matters: tax on the pre-discount amount would be a different (wrong) number.

6. **Print.** Fixed-width `printf` formats keep the columns aligned; the sign of money is printed separately so negative discounts read `-$7.93`. Customers are sorted with `sort`, and items follow the price list, so output is stable.

## Complete solution
Key helpers:
```bash
round_div() { echo $(( ($1 + $2 / 2) / $2 )); }
line_cost() {
  local qty=$2 prev=0 total=0 t upto price top
  for t in ${tiers[$1]}; do
    upto=${t%%:*}; price=${t#*:}
    if [[ $upto == '*' ]]; then top=$qty; else top=$(( qty < upto ? qty : upto )); fi
    (( top > prev )) && total=$(( total + (top - prev) * price ))
    [[ $upto == '*' ]] && break
    prev=$upto
    (( qty <= upto )) && break
  done
  echo "$total"
}
```

## Try it by hand
```bash
TAX_PCT=8 MIN_CHARGE=500 ./solution.sh fixtures/prices.txt fixtures/usage.csv fixtures/discounts.txt
./solution.sh fixtures/prices.txt fixtures/usage.csv
```

## Alternative
`awk` can do decimals natively, but floating point cannot represent 0.0125 or 0.1 exactly, and the error shows up as a cent that is off by one on exactly the invoice the customer disputes. Integers keep the arguments short.
