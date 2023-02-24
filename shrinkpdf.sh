#!/bin/bash
#Enable the debugging
set -x

# Shrinks PDFs and puts them in a subdirectory of the first file
# Usage: shrinkpdf.sh file1 file2 ...

# Location of the Ghostscript executable
# TODO Need to deploy, change path
# Use deploy into server Linux
#GSPATH="$(dirname "$0")/gs10.0.0-linux/gs-1000-linux-x86_64"
# Use in local pc, win or mac only
GSPATH="gs"
echo $GSPATH

# Name of the subdirectory to store the shrunk files to
OUTSUBDIR="$2"

# Set Out file
OUTFILE="`basename "$1"`"

# Create the log directory if it does not exist
LOGDIR="$(dirname "$0")/logs"
if [ ! -d "$LOGDIR" ]; then
  mkdir "$LOGDIR"
fi

# Set the name of the log file
LOGFILE="$LOGDIR/shrinkpdf.log"
LOGFILE_ERR="$LOGDIR/shrinkpdf_err.log"

# Create the log file if it doesn't exist
touch "$LOGFILE"
touch "$LOGFILE_ERR"

# Set the format for the date and time
DATE_FORMAT="+%Y-%m-%d %H:%M:%S"

if [ -z "$1" ]; then
  echo "$(date "$DATE_FORMAT") Usage: shrinkpdf.sh "$1" "$2" ..." >> "$LOGFILE"
  exit 1
fi



# Take the path of the first file and use it as the folder
# to create the shrunk directory under
OUTDIR="$OUTSUBDIR"

# Create the output folder if it doesn't exist
if [ ! -d "$OUTDIR" ]; then
  mkdir "$OUTDIR"
  echo "$(date + $DATE_FORMAT) OUTDIR create: $OUTDIR" >> "$LOGFILE"
fi

# Create a temporary file to capture stderr output
#trap 'rm -f "$LOGFILE_ERR"' EXIT

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
    -sOutputFile="$OUTDIR/$OUTFILE" \
    "$1"
}

# Catch errors
#trap 'echo "$(date "$DATE_FORMAT") ERROR: Command failed: $BASH_COMMAND" >> "$LOGFILE"' ERR
# Shrink all PDF files
# Loop through all PDF files and shrink them
echo "$(date "$DATE_FORMAT") $3 Processing $(basename "$1")" >> "$LOGFILE"
if shrinkPDF "$1"; then
  echo "$(date "$DATE_FORMAT") Finished processing $(basename "$1")" >> "$LOGFILE"
else
  echo "$(date "$DATE_FORMAT") Error processing $(basename "$file")" >> "$LOGFILE"
fi
