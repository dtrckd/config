#!/bin/env sh
python -c "import sys; from rich.console import Console; Console().print(eval(sys.stdin.read().strip()))"
