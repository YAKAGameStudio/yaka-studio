#!/bin/bash

# Check if website.json exists
if [ ! -f "website.json" ]; then
    echo "website.json not found!"
    exit 1
fi

# Read the JSON file
pages=$(cat website.json | jq -r '.pages[]')

# Loop through each page entry
for page in $pages; do
    # Extract the file name
    filename=$(echo $page | jq -r '.filename')

    # Create the file
    touch $filename

    # Add content to the file
    echo $page > $filename

    # Print a success message
    echo "Created $filename"
done