# Common Mistakes

- **Forgetting the dollar sign.** `echo "Ahoy, 1!"` prints a literal `1`.
  Right: `echo "Ahoy, $1!"`.
- **Using the script's name by accident.** `$0` is the script itself, not the
  first argument. `echo "Ahoy, $0"` prints `Ahoy, solution.sh`.
- **Expecting spaces to be kept without quotes.** `./solution.sh Tidewater Books`
  gives `$1=Tidewater` and `$2=Books`. The caller must write `"Tidewater Books"`.
- **Writing `$1` as an assignment target.** `1=Harbour` is not valid Bash;
  copy it instead: `customer=$1`.
