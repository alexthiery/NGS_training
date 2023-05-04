#!/bin/bash

######################################
# Script usage:
# This script selects files with the .bigWig extension from an input directory,
# converts them to the .wig format, and then converts them back to bigWig format
# including only the chrM chromosome. The output files are saved in the output
# directory specified by the user.
#
# Usage: ./convert_bigWig.sh <input_dir> <output_dir> <chrom_sizes> <chrom_name>
#   input_dir:      Directory containing input bigWig files
#   output_dir:     Directory to save output files
#   chrom_sizes:    Path to chrom.sizes file for conversion to bigWig
#   chrom_name:     Chromosome name for filtering (e.g. chrM)
#
# Requirements:
# This script requires the bigWigToWig and wigToBigWig commands to be installed
# on your system and available in the PATH.
######################################

# Check that all required arguments are provided
if [ $# -ne 4 ]; then
    echo "Usage: ./convert_bigWig.sh <input_dir> <output_dir> <chrom_sizes> <chrom_name>"
    exit 1
fi

# Define input and output directories and chrom.sizes file
input_dir="$1"
output_dir="$2"
chrom_sizes="$3"
chrom_name="$4"

# Create output directory if it doesn't exist
if [ ! -d "${output_dir}" ]; then
    mkdir "${output_dir}"
fi

# Loop through all .bigWig files in the input directory
for file in "${input_dir}"/*.bigWig; do
    # Get the filename without extension
    filename=$(basename -- "$file")
    filename="${filename%.*}"

    # Convert bigWig to wig
    bigWigToWig -chrom="${chrom_name}" "${file}" "${output_dir}/${filename}.wig"

    # Convert wig to bigWig with chrM chromosome only
    wigToBigWig "${output_dir}/${filename}.wig" "${chrom_sizes}" "${output_dir}/${filename}_${chrom_name}.bigWig"

    # Remove intermediate .wig file
    rm "${output_dir}/${filename}.wig"
done
