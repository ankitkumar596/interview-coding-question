#!/bin/bash

function sum_all() {
    local a=$1
    local b=$2
    local start
    local end
    local total_sum=0

    # Determine the minimum and maximum values
    if (( a < b )); then
        start=$a
        end=$b
    else
        start=$b
        end=$a
    fi

    # Sum all numbers from start to end
    for (( i=start; i<=end; i++ )); do
        total_sum=$(( total_sum + i ))
    done

    echo $total_sum
}

# Example usage:
sum_all 1 4  # Output: 10
