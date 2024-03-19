#!/bin/bash

# Check if exactly two arguments are provided
if [ $# -ne 2 ]; then
  echo "Error: You must provide exactly two boolean arguments the manual and the retry."
  exit 1
fi

# Assign arguments to variables
retry="$2"
manual="$1"

# Check the value of retry and execute commands accordingly
if [ "$retry" = "false" ]; then
    echo "Beggining the verification process for the first time"
    python3 prompt_creator.py
    python3 files_creator.py  $manual $retry
    ./verification_infer.sh 
    ./verification_klee.sh
  # Place Command 1 here
elif [ "$retry" = "true" ]; then
    echo "Starting the verification process again to correct the error."
    python3 prompt_recreator.py
    python3 files_creator.py  $manual $retry
    ./verification_infer.sh 
    ./verification_klee.sh
  # Place Command 2 here
else
  echo "Error: The value of retry should be either 'true' or 'false'."
  exit 1
fi

# Use the value of manual as needed
# You can add conditions to check the value of manual and execute commands similarly
