#!/bin/sh

DIR=${1:-.}

# Find all .dart files and count lines
find "$DIR" -type f -name "*.dart" | while read file; do
    lines=$(wc -l < "$file")
    echo "$lines $file"
done | sort -nr
