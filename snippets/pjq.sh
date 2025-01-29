#!/bin/env sh
python -c "
import sys
import json
from rich.console import Console

inputs = sys.stdin.read().strip()
try:
    python_inputs = eval(inputs)
except:
    Console().print(inputs)
    sys.exit(2)

Console().print(python_inputs)
"
