#!/bin/bash

# Shrinks PDFs and puts them in a subdirectory of the first file
# Usage: shrinkpdf.sh file1 file2 ...

# Location of the Ghostscript executable
# TODO Need to deploy, change path
#GSPATH="$(dirname "$0")/gs10.0.0-linux/gs-1000-linux-x86_64"
GSPATH="gs"
echo $GSPATH

# Name of the subdirectory to store the shrunk files to
OUTSUBDIR="$2"

if [ -z "$1" ]; then
  echo "Usage: shrinkpdf.sh file1 file2 ..."
  exit 1
fi

# Take the path of the first file and use it as the folder
# to create the shrunk directory under
OUTDIR="$OUTSUBDIR"

# Create the output folder if it doesn't exist
if [ ! -d "$OUTDIR" ]; then
  mkdir "$OUTDIR"
fi

shrinkPDF() {
  # Work the shrinking magic
  # Based on http://www.alfredklomp.com/programming/shrinkpdf/
  "$GSPATH" -q -dNOPAUSE -dBATCH -dSAFER \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/screen \
    -dEmbedAllFonts=true \
    -dSubsetFonts=true \
    -dColorImageDownsampleType=/Bicubic \
    -dColorImageResolution=100 \
    -dGrayImageDownsampleType=/Bicubic \
    -dGrayImageResolution=100 \
    -dMonoImageDownsampleType=/Bicubic \
    -dMonoImageResolution=100 \
    -sOutputFile="$OUTDIR/$(basename "$1")" \
    "$1"
}

# Shrink all PDF files
for file in "$@"; do
  echo "Processing $(basename "$file")"
  shrinkPDF "$file"
done
