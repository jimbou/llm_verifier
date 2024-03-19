#!/bin/bash

# Check if two numbers are provided as arguments
if [ $# -ne 2 ]; then
  echo "Error: You must provide exactly 2 arguments , 1 numbers : the maximum number of retries (0 to 5) and a boolean(if you will do manual calls to llm yourself , if false the api is used)."
  exit 1
fi


# Correctly assign values to variables without spaces around '='
num1=0
num2=$1
manual=$2

echo "This is our first run"
./total_runner.sh "$manual" false

# Correct syntax for the while loop condition
while true; do
    
    conditionMet=0
    

    # Path to the files you want to check
    file1="error_report_klee.txt"
    file2="error_report_infer.txt"

    # Check if file1 contains the word "error" (case-sensitive; use 'Error' if looking for exactly 'Error')
    if grep -qi "error" "$file1"; then
        conditionMet=1
        echo "Error found by klee"
    fi

    # Check if file2 contains the phrase "Found X issue" where X is a number
    if grep -qE "Found [0-9]+ issue" "$file2"; then
        conditionMet=1
        echo "Error found by infer"
    fi

    # If any condition is met, perform the retry logic
    if [ $conditionMet -eq 1 ]; then
        if [ "$num1" -ge "$num2" ]; then
            echo "Exiting: The maximum number of retries has been reached"
            exit 1
        fi
        echo "Retrying the verification process"
        ./total_runner.sh "$manual" true
        # Increase the value of num1 by 1
        num1=$((num1 + 1))
    else
        echo "No errors found, the code provided by the llm has been verified"
        exit 0
    fi
done
