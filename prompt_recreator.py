import re

import os

# Check if 'function_input.c' exists and delete it if it does

if os.path.exists('template_retry_modified.c'):
    os.remove('template_retry_modified.c')

# Ask for user input and store responses
# Create an empty file for the user to input their unfinished function


# Read the user's function from the file
with open('infer_analysis.c', 'r') as file:
    var1 = file.read()

with open('desired_output.txt', 'r') as file:
    var2 = file.read()
with open('additional_context.txt', 'r') as file:
    var3 = file.read()
with open('necessary_include.txt', 'r') as file:
    var4 = file.read()

with open('klee_main.c', 'r') as file:
    var5 = file.read()

with open('error_report.txt', 'r') as file:
    var6 = file.read()

# Remove trailing '}' possibly followed by whitespaces from var1


# Read the template file
with open('template_retry.c', 'r') as file:
    file_contents = file.read()

# Replace the placeholders with user input
file_contents = file_contents.replace('//placeholder4', var1)
file_contents = file_contents.replace('placeholder1', var2)
file_contents = file_contents.replace('placeholder2', var3)
file_contents = file_contents.replace('//placeholder3', var4)
file_contents = file_contents.replace('//placeholder6', var5)
file_contents = file_contents.replace('//placeholder5', var6)
# Write the modified content back to the file (or to a new file if preferred)
with open('template_retry_modified.c', 'w') as file:
    file.write(file_contents)

print("The template has been successfully modified.")
