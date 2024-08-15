#!/usr/bin/bash

# Check if a string argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <string>"
    exit 1
fi

# string=$1 ankit
# reversed=''

# # Reverse the string
# for ((i = 0; i < ${#string}; i++)); do
#     reversed="${string:i:1}$reversed"
# done

# # Output the reversed string
# echo "$reversed"

################################################

#!/usr/bin/bash

# string=$1

# reversed=''

# # Loop through the string from the end to the beginning
# for ((i = ${#string} - 1; i >= 0; i--)); do
#     reversed+="${string:i:1}"
# done

# echo "$reversed"


#####################################################

#!/usr/bin/bash

string=$1

# Convert the string into an array of characters
chars=($(echo "$string" | fold -w1))

reversed=''

# Iterate over the array
for i in "${chars[@]}"; do
    reversed="$i$reversed"
done

echo "$reversed"

