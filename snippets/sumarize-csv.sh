#!/bin/bash

# Function to summarize a single CSV file
summarize_csv() {
    local file="$1"

    # Get file size in kilobytes
    local size=$(stat --printf="%s" "$file")
    local size_kb=$((size / 1024))"ko"

    # Get the number of lines (excluding the header)
    local num_lines=$(($(wc -l < "$file") - 1))

    # Get the header line
    local header=$(head -n 1 "$file" | tr -d '\r')

    # Determine the delimiter and number of columns
    local delimiter=","
    if [[ "$header" == *";"* ]]; then
        delimiter=";"
    fi

    local num_cols=$(awk -F"$delimiter" '{print NF; exit}' <<< "$header")
    local column_names=$(echo "$header" | sed "s/$delimiter/, /g")

    # Output the summary with aligned columns
    printf "%-40s | %-10s | %-10s | %-50s\n" "$file" "$size_kb" "$num_lines rows" "$num_cols cols ($column_names)"
}

# Print the header
printf "%-40s | %-10s | %-10s | %-50s\n" "File" "Size" "Rows" "Columns"

# Print the horizontal separator
printf '%.0s-' {1..95}
echo

# Check if $1 is empty, if so iterate over all CSV files in the current directory
if [ -z "$1" ]; then
    for csv_file in *.csv; do
        if [[ -f "$csv_file" ]]; then
            summarize_csv "$csv_file"
        fi
    done
else
    # Use $* as the file to run on
    for file in "$@"; do
        summarize_csv "$file"
    done
fi
