#!/bin/bash

function check_odd_even() {
    if (( $number % 2 == 0 )); then  # Corrected the modulo condition
        echo "Number $number is even"  # Corrected 'ehco' to 'echo'
    else
        echo "Number $number is odd"
    fi
}

if [ "$#" -eq 1 ]; then 
    number=$1
    check_odd_even $number  # Changed 'input' to 'number'
else
    read -p "Enter the number: " number
    if [[ "$number" =~ ^[0-9]+$ ]]; then  # Corrected the regex for numeric validation
        check_odd_even $number
    else
        echo "Error: Invalid input, please enter a valid number."
    fi
fi
