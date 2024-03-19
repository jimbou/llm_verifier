#!/bin/bash

# Define the directory to search and the output file
search_dir="klee-last"
output_file="output.txt"

# Ensure output file is empty
> "$output_file"

# Loop through all .err files in the specified directory
for err_file in "$search_dir"/*.err; do
    # Check if no .err files are found
    if [ "$err_file" = "$search_dir/*.err" ]; then
        echo "No .err files found in $search_dir"
        break
    fi

    # Copy the content of the .err file to the output file
    cat "$err_file" >> "$output_file"
    echo "" >> "$output_file"  # Ensure a newline after the content

    # Extract the name up to the first dot
    base_name=$(basename "$err_file" .err)  # Removes the path and the .err extension
    prefix="${base_name%%.*}"  # Extracts the substring up to the first dot
    echo "Processing $prefix.ktest"
    # Run the ktest-tool command and append the results to the output file
    ktest_tool_output=$(ktest-tool "$search_dir/$prefix.ktest")
    echo "$ktest_tool_output" >> "$output_file"
    echo "" >> "$output_file"  # Ensure a newline for readability
done

echo "Process completed. Results are in $output_file."
