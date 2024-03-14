import os

import sys

# Check if the user has provided a filename as an argument
if len(sys.argv) < 2:
    print("Usage: python script.py <filename>")
    sys.exit(1)

filename = sys.argv[1]

# Function to read the content between two markers
def read_content_between(file_contents, start_marker, end_marker):
    start_index = file_contents.find(start_marker) + len(start_marker)
    end_index = file_contents.find(end_marker)
    if start_index != -1 and end_index != -1 and start_index < end_index:
        return file_contents[start_index:end_index].strip()
    return ''

# Read from the source file
with open(filename, 'r') as file:
    content = file.read()

# Extract content for var1 and var2
var1 = read_content_between(content, 'start_function', 'end_function')
var2 = read_content_between(content, 'start_main', 'end_main')

# Function to create or overwrite a file with specified content
def write_to_file(filename, data):
    if os.path.exists(filename):
        os.remove(filename)
    with open(filename, 'w') as file:
        file.write(data)

# Write var1 to 'infer_analysis.c'
write_to_file('infer_analysis.c', var1)
write_to_file('klee_main.c', var2)

# Format content for 'klee_analysis.c' and write
klee_content = f'#include <klee/klee.h>\n\n{var1}\n\n{var2}'
write_to_file('klee_analysis.c', klee_content)

print("Files 'infer_analysis.c' and 'klee_analysis.c' and klee_main.c have been successfully created.")
