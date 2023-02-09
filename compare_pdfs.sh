#!/bin/bash

# Compare all PDF files in two folders
# How to use
# Mac:  brew install imagemagick
# brew install poppler imagemagick
# chmod +x compare_pdfs.sh
# Terminal: ./compare_pdfs.sh folder1 folder2
# Example: ./compare_pdfs.sh /Users/minhvq/Downloads/comparePDF_FG/01053_0007_old /Users/minhvq/Downloads/comparePDF_FG/01053_0007-1_new
# Note: Should be seperate folder old-new, the same filename to compare

# Check if the number of arguments is correct
if [ $# -ne 2 ]; then
  echo "Usage: compare_pdfs.sh folder1 folder2"
  exit 1
fi

# Replace spaces in filenames with underscores for folder 1
folder1=$1
for file in "$folder1"/*; do
  if [ -f "$file" ]; then
    new_file=${file// /_}
    mv "$file" "$new_file"
  fi
done

# Replace spaces in filenames with underscores for folder 2
folder2=$2
for file in "$folder2"/*; do
  if [ -f "$file" ]; then
    new_file=${file// /_}
    mv "$file" "$new_file"
  fi
done

# Create an array to store the names of the difference images
declare -a diff_images

# Compare all PDF files in both folders
for file1 in "$folder1"/*.pdf; do
  file2="$folder2/$(basename "$file1")"
  if [ -f "$file2" ]; then
    # Get the number of pages in each PDF file
    pages1=$(pdfinfo "$file1" | grep Pages | awk '{print $2}')
    pages2=$(pdfinfo "$file2" | grep Pages | awk '{print $2}')
  
    # Compare the pages one by one
    for i in $(seq 1 $pages1); do
      # Check if the number of pages in both files is the same
      if [ $i -gt $pages2 ]; then
        echo "Error: The number of pages in both PDF files is not the same."
        exit 1
      fi
    
      # Compare the current page
      compare -density 150 "$file1"[$(($i-1))] "$file2"[$(($i-1))] "difference_$(basename "$file1")_$i.png"
    
      # Add the difference image to the array
      diff_images[$i]=difference_$(basename "$file1")_$i.png
    done

    # Join all difference images into one PDF file
    convert "${diff_images[@]}" "result_$(basename "$file1").pdf"

    # Display the result
    display "result_$(basename "$file1")"
    # Remove the difference images after join
    rm "${diff_images[@]}" 
  fi
done
