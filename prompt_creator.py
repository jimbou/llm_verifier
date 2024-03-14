import re

import os

# Check if 'function_input.c' exists and delete it if it does
if os.path.exists('function_input.c'):
    os.remove('function_input.c')
if os.path.exists('template_modified.c'):
    os.remove('template_modified.c')

# Ask for user input and store responses
# Create an empty file for the user to input their unfinished function
open('function_input.c', 'w').close()
print("An empty file named 'function_input.c' has been created. Please write your unfinished function there and save the file.")

# Wait for user confirmation
input("Press Enter after you have finished writing your function in 'function_input.c'...")

# Read the user's function from the file
with open('function_input.c', 'r') as file:
    var1 = file.read()

var2 = input("2) What is the output you want? ")
var3 = input("3) What is additional context to help us create the assertions. What is an acceptable range for the variables both input and output? ")
var4 = input("4) What are the necessary include functions so far? Please provide them in this format: #include <stdio.h> etc: ")

# Remove trailing '}' possibly followed by whitespaces from var1
var1 = re.sub(r"}\s*$", "", var1)

# Read the template file
with open('template.c', 'r') as file:
    file_contents = file.read()

# Replace the placeholders with user input
file_contents = file_contents.replace('//placeholder4', var1)
file_contents = file_contents.replace('placeholder1', var2)
file_contents = file_contents.replace('placeholder2', var3)
file_contents = file_contents.replace('//placeholder3', var4)

# Write the modified content back to the file (or to a new file if preferred)
with open('template_modified.c', 'w') as file:
    file.write(file_contents)

print("The template has been successfully modified.")


def write_to_file(filename, data):
    if os.path.exists(filename):
        os.remove(filename)
    with open(filename, 'w') as file:
        file.write(data)

# Write var1 to 'infer_analysis.c'
write_to_file('desired_output.txt', var2)
write_to_file('additional_context.txt', var3)
write_to_file('necessary_include.txt', var4)