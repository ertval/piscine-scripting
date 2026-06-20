#!/usr/bin/env bash
set -euo pipefail

cat << 'EOF' > show-info.sh
#!/usr/bin/env bash
cat -e <<INFO
The current directory is: $PWD
The default paths are: $PATH
The current user is: $USERNAME

INFO
EOF
