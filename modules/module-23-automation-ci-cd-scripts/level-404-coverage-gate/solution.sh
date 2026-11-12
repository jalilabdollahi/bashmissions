#!/usr/bin/env bash
set -euo pipefail
# Coverage gate: read "path covered total" lines from the report and decide
# whether the overall coverage reaches the threshold. No floating point!

# TODO 1: validate THRESHOLD (0-100, digits only) and that REPORT is readable.
# TODO 2: read the report, skipping blank and "#" lines but still counting them.
# TODO 3: sum covered and total; remember each file for the "low:" lines
#         (a second pass, or an array, because the overall figure comes first).
# TODO 4: percentage with one decimal = (covered*1000 + total/2) / total, then
#         print it as "${t/10}.${t%10}".
# TODO 5: PASS when covered*100 >= threshold*total, else FAIL with exit 1.
