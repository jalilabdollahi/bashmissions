#!/usr/bin/env bash
# Invoice generator for the storm-month bills. Tiered price list + usage CSV in,
# one invoice per customer out, all money in integers and rounded half up.
#   solution.sh PRICES USAGE [DISCOUNTS]
# Environment: TAX_PCT and MIN_CHARGE (cents), both default 0.

# TODO: arguments, readable files, TAX_PCT / MIN_CHARGE validation
# TODO: parse PRICES: item, unit, tiers "UPTO:PRICE"; store prices as 1/10000 dollar
# TODO: validate the tiers (increasing UPTO, last one is *) -> "bad price line N"
# TODO: line_cost ITEM QTY: graduated across the tiers
# TODO: round_div for half-up rounding, and a money formatter for cents
# TODO: read DISCOUNTS (optional) and USAGE; sum rows per customer and item
# TODO: sorted customers, items in price-list order, subtotal/discount/minimum/tax/total
# TODO: grand total line; exit 1 when rows were skipped
