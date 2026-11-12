# Debrief: Follow Pagination

## What you learned

APIs never return "everything": a list of a million invoices would be a disaster for the server and for you. They return a **page** plus a **cursor** (here, a `next` pointer). The client's job is a loop: ask, process, follow the cursor, stop when there is none. Your first version fetched one page and silently reported a partial truth, which is the classic pagination bug.

## Under the hood

The loop condition lives in a variable set from the response itself. That is a general pattern for any "keep going until the server says stop" protocol. Because the server controls when the loop ends, a defensive limit is not paranoia; it is how you survive a bug on the other side (here, a page that links to itself).

Note the small trick with `null`. The sed pattern only matches a quoted string value, so `null` produces an empty result and doubles as the stop signal. In production you would parse real JSON, but the control flow would be identical.

Printing ids as they arrive, rather than gathering them first, means a failure on page 4 still leaves you with pages 1 to 3, which is often more useful than nothing.

## In real work

GitHub, Stripe, cloud inventories: all page their lists, with cursors, page numbers or `Link` headers. Exports, audits and syncs always need this loop.

## Going further

You have spent a module speaking HTTP. Next you will look below it: is a TCP port even accepting connections?
