# Common Mistakes

- **Charging every unit at the tier you landed in.** For 1500 GB that bills all of it at 0.03. Tiers are graduated: only the units above the previous limit use the next price.
- **Floating point or `bc`.** `0.0125 * 720` in binary floating point is not exactly 9. Keep prices as integers (`125` ten-thousandths) and round once.
- **Rounding at the wrong moment.** Rounding after the sum makes the total differ from the visible lines by a cent. Round each item line, then add.
- **Truncating instead of rounding half up.** `$(( x / 100 ))` turns 2.5 cents into 2. Use `(x + 50) / 100`.
- **Tax before the discount.** The tax base is the amount after discount and minimum charge. Changing the order changes the cents.
- **Octal numbers.** `qty=08` breaks `$(( ))` with "value too great for base". Use `10#$q`.
- **Dropping the header by accident.** Skipping line 1 unconditionally also drops a real first row when the file has no header.
