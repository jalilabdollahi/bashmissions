# Walkthrough: Comments Are for Humans

## The plan
We want three changes in one file: silence two debug lines, keep them for later, and label the file. A `#` does the first two at once, and a block of comments does the third.

## Step by step
1. Run the starter. The two DEBUG lines are mixed into the output.
2. Put `#` at the start of each DEBUG line. Bash now skips them, but they stay in the file for the future.
3. Under the shebang line add the header. Convention: what the script does, who wrote it, maybe a date or a ticket number.
4. Run the script again and compare the two real lines with the objective.

## Complete solution

```bash
#!/usr/bin/env bash
# Purpose: warm the page cache for Tidewater Books and report the page count.
# Author: your name here

#echo "DEBUG: entering warm-up"
echo "Warming the cache for Tidewater Books"
#echo "DEBUG: pages = 3"
echo "Cache warm: 3 pages"
```

## Trying it by hand
Run `bash solution.sh`. Delete one `#` and run again to see the debug line come back. That is the whole benefit of commenting out.

## An alternative
You can delete the debug lines, and the output will be identical. But then the knowledge of how to debug the script is gone, and version control is not always at hand. Commenting out is a temporary measure; once you are sure, removing the lines is also fine.
