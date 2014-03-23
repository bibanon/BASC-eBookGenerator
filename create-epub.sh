#!/bin/bash
# BASC EPUB Generator Bash Script
# Uses Pandoc and Kindlegen to quickly create EPUB and MOBI ebooks.

# check that the ebook filename is given
# give a usage help prompt and exit if not
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ebook-filename>"
    exit 1
fi

# filename of the ebook = the first argument
EBOOK_NAME=$1

# create epub from markdown
pandoc my-ebook.md -o "$EBOOK_NAME.epub" --toc

# validate the epub
#java -jar ./epubcheck-3.0.1/epubcheck-3.0.1.jar "$EBOOK_NAME.epub"

# create mobi format ebook
kindlegen "$EBOOK_NAME.epub" -o "$EBOOK_NAME.mobi"