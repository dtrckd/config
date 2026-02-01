#!/bin/bash

# Create the directory if it doesn't exist
mkdir -p /home/dtrckd/.claude

# Gather system information
OS_INFO=$(uname -sr)
PYTHON_VERSION=$(python3 --version 2>/dev/null || echo "Not installed")
GO_VERSION=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//' || echo "Not installed")
NODE_VERSION=$(node --version 2>/dev/null | sed 's/v//' || echo "Not installed")
TERMINAL_INFO=$(echo $TERM)
SHELL_INFO=$(fish --version 2>/dev/null || echo $SHELL)

# Generate the CLAUDE.md file
cat > /home/dtrckd/.claude/CLAUDE.md << EOF
Your user runs on a Debian/Linux machine, with xfce4 graphical interface.
- OS version: $OS_INFO
- Python version: $PYTHON_VERSION
- Go version: $GO_VERSION
- Node version: $NODE_VERSION
- Terminal: $TERMINAL_INFO
- Shell: $SHELL_INFO

EOF

echo "File created successfully at /home/dtrckd/.claude/CLAUDE.md"
