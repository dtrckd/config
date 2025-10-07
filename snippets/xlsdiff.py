#!/usr/bin/env python

import pandas as pd
from rich.console import Console
from rich.text import Text
from rich.syntax import Syntax
import difflib
import argparse
import signal
import os


def handle_broken_pipe_error(signum, frame):
    """Handle broken pipe signal by using os._exit."""
    os._exit(0)


def generate_diff_lines(from_lines, to_lines, show_only_differences):
    # Generate a unified diff
    diff = list(difflib.unified_diff(from_lines, to_lines, lineterm=""))

    # Prepare a rich console for colored output
    console = Console()

    if show_only_differences:
        diff = [line for line in diff if line.startswith(("+", "-", "@"))]

    # Print out the diff line-by-line with colors
    for line in diff:
        if line.startswith("+") and not line.startswith("+++"):
            console.print(Text(line, style="bold green"))
        elif line.startswith("-") and not line.startswith("---"):
            console.print(Text(line, style="bold red"))
        elif line.startswith("@"):
            console.print(Syntax(line, "diff", theme="ansi_dark", background_color="default"))
        else:
            console.print(line)


def compare_excel(file1, file2, sheet_name=None, show_only_differences=False):
    # Load Excel files
    _df1 = pd.read_excel(file1, sheet_name=sheet_name)
    _df2 = pd.read_excel(file2, sheet_name=sheet_name)

    if isinstance(_df1, dict) or isinstance(_df2, dict):
        sheet_names = list(set(list(_df1) + list(_df2)))
    else:
        sheet_names = [sheert_name]

    for sheet_name in sheet_names:
        # Load Excel files
        print("Loading file for sheet: %s" % sheet_name)
        try:
            df1 = pd.read_excel(file1, sheet_name=sheet_name).fillna("")
            df2 = pd.read_excel(file2, sheet_name=sheet_name).fillna("")
        except Exception as err:
            print("Error while reading file for sheet '%s': %s" % (sheet_name, err))
            continue

        #if isinstance(df1, dict):
        #    print("You need to specify a sheet to diff.")
        #    print("Available sheets: %s" % list(df1))
        #    return

        # Remove Unamed Colums
        new_dfs = []
        for df in [df1, df2]:
            columns_to_drop = df.filter(regex="^Unnamed").columns
            df = df.drop(columns=columns_to_drop)
            new_dfs.append(df)
        df1, df2 = new_dfs

        print("Columns:", df2.columns.tolist())
        c1 = sorted(df1.columns.tolist())
        c2 = sorted(df2.columns.tolist())
        if str(c1) != str(c2):
            print(
                "Some columns are present only in one df: %s"
                % (set(c1 + c2) - set(c1).intersection(set(c2)))
            )

        # Concatenate row values for each file
        df1_rows = df1.apply(lambda row: " || ".join(str(v) for v in row), axis=1)
        df2_rows = df2.apply(lambda row: " || ".join(str(v) for v in row), axis=1)

        # Convert Series to list of strings for difflib
        from_lines = df1_rows.tolist()
        to_lines = df2_rows.tolist()

        # Generate and display diff lines
        generate_diff_lines(from_lines, to_lines, show_only_differences)
        print()


def main():
    # Set signal handler for SIGPIPE
    signal.signal(signal.SIGPIPE, handle_broken_pipe_error)

    parser = argparse.ArgumentParser(description="Compare two Excel files and print differences.")
    parser.add_argument("file1", type=str, help="The path to the first Excel file.")
    parser.add_argument("file2", type=str, help="The path to the second Excel file.")
    parser.add_argument("--sheet", type=str, default=None, help="Specify the sheet to compare.")
    parser.add_argument(
        "-s",
        "--short",
        action="store_true",
        help="Show only line numbers for modified (~), added (+), or removed (-) lines.",
    )

    args = parser.parse_args()

    try:
        compare_excel(args.file1, args.file2, args.sheet, args.short)
    except BrokenPipeError:
        # Exit gracefully on broken pipe using os._exit
        os._exit(0)


if __name__ == "__main__":
    main()
