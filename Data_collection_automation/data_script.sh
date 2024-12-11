#!/bin/bash
# Script Name: collect_data.sh
# Author: Chiranjeet Das
# Date Created: 2024-12-11
# Description: This script collects and processes the output of the `ldd` command on a vulnerable C program.
#              It extracts the libc library path and memory address and saves them as data points to a CSV file.

# Compile the vulnerable C program
gcc -o vulnerable vulnerable.c

# Prompting the user to enter the path to the vulnerable C program
read -p "Give the vulnerable binary :: " path

# Prompting the user to specify the path for saving the output data (CSV file)
read -p "Path for the data (CSV file) :: " path_1

# Initializing a count variable for tracking epochs (iterations)
count=1

# Check if the CSV file exists. If not, create it and add headers
if [ ! -f "$path_1" ]; then
    echo "epoch,libc_path,libc_address" > "$path_1"
fi

# Displaying a message indicating that the data collection has started, along with the current epoch
echo "[*] Collecting data epoch -->  $count"

# Infinite loop to repeatedly collect data and save it to the specified CSV file
while true; do
    # Use 'ldd' to get the dynamic dependencies and filter out the 'libc' library path and memory address
    libc_output=$(ldd "$path" | grep libc)
    
    # Save the data to the CSV file in the format: epoch,libc_path,libc_address
    echo "$libc_output" >> "$path_1"
    
    # Increment the count variable after each iteration
    count=$((count + 1))
    
    # Optional: break the loop after a certain number of iterations (e.g., 10 iterations)
    # Uncomment the following line to break the loop after 10 epochs
    # if [ "$count" -gt 10 ]; then break; fi
    echo "Epoch -> $count completed"
done


