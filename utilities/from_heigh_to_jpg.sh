#!/usr/bin/env bash

# Ensure ImageMagick is installed and HEIC support is enabled
if ! command -v mogrify &> /dev/null; then
  echo "Error: mogrify command not found. Please install ImageMagick."
  exit 1
fi

# Directory containing HEIC files
input_dir=${1:-"./"} # Defaults to current directory if no argument is provided

# Output directory for JPGs
output_dir="${input_dir}/jpg_output"
mkdir -p "$output_dir"

# Convert all HEIC files in the input directory to JPG
echo "Converting HEIC files to JPG..."
for file in "$input_dir"/*.HEIC "$input_dir"/*.heic; do
  if [ -f "$file" ]; then
    base_name=$(basename "$file" .HEIC)
    base_name=$(basename "$base_name" .heic)
    output_file="$output_dir/${base_name}.jpg"
    mogrify -format jpg -path "$output_dir" "$file"
    echo "Converted: $file -> $output_file"
  fi
done

echo "Conversion completed! JPGs are in the folder: $output_dir"
