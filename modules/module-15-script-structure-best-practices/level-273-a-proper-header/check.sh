#!/usr/bin/env bash
# Verifies the header: portable shebang and a Description comment.
if [ "$(head -n 1 solution.sh)" != '#!/usr/bin/env bash' ]; then
  echo "Line 1 must be exactly: #!/usr/bin/env bash"
  exit 1
fi
if ! head -n 8 solution.sh | grep -Eq '^# Description: .{8,}'; then
  echo "Add a comment like '# Description: what this script does' within the first 8 lines."
  exit 1
fi
exit 0
