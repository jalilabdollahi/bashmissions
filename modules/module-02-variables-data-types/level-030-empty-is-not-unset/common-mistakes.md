# Common Mistakes

- **Using the colon form for a field that may be blank on purpose.**
  Wrong: `${NOTE:-(no note on file)}` replaces a deliberately cleared note.
  Right: `${NOTE-(no note on file)}`.
- **Using the no-colon form for a required value.**
  Wrong: `${CONTACT-support@lanternfish.example}` leaves `contact=[]` when the field is blank.
  Right: `${CONTACT:-support@lanternfish.example}`.
- **Testing with a quoted empty string.**
  `NOTE=""` sets the variable to empty; it does not unset it. To test the unset case, leave the assignment out or run `unset NOTE`.
- **Hiding the difference.** Printing `$NOTE` bare makes empty and unset look the same. Square brackets around the value make the state visible while you debug.
