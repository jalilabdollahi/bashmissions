# Common Mistakes

- **Trusting the regex for the range.** `^[0-9]{1,3}(\.[0-9]{1,3}){3}$` happily
  accepts `256.300.1.1`. The shape is right; the numbers are not.
- **Forgetting `10#`.** `(( 08 > 255 ))` fails with "value too great for base"
  because `08` is octal. Write `(( 10#$octet > 255 ))`.
- **Repeating a group and expecting all values.** `^([0-9]{1,3})(\.[0-9]{1,3}){3}$`
  captures only the *last* repetition of the second group. Write the four
  groups out when you need each value.
- **Unescaped dots.** `([0-9]{1,3}).` matches `1x2x3x4`. Use `\.`.
- **Slicing the wrong range.** `"${BASH_REMATCH[@]}"` includes element 0, the whole
  string, which is not an octet (`1.2.3.4`), and is a big "number". Use `[@]:1:4`.
