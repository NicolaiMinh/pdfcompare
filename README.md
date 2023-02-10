# PDF compare using imagemagick

Compare contents PDF file using imagemagick

Mac install:

```
brew install imagemagick
brew install poppler imagemagick
```

How to run:
1. Make two folders old and new to contains old file PDF and new file PDF for comparation.
2. Create same filename, same pages size.

Command:

```
chmod +x compare_pdfs.sh
./compare_pdfs.sh folder1 folder2
```

# Compress PDF using shrinkpdf

Mac install:

```
brew install ghostscript
```
How to run:
1. Prepare file PDF to compress.
2. Export folder compress contain file reduce size.


Command:

```
chmod +x shrinkpdf.sh
./shrinkpdf.sh ./${folderPath}${fileName}  ./${folderPath}compress
```
