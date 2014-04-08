#!/bin/bash

# BASC EPUB Generator Bash Script
# Uses Pandoc and Kindlegen to quickly create EPUB and MOBI ebooks.

# usage prompt
usage(){
        echo "Usage: $0 <ebook-folder-1> <ebook-folder-2> ..."
        echo "     : $0 --compile-all-ebooks"
        exit 1
}

# folder name structure
PAGES_FOLDER="pages"
IMAGE_FOLDER="images"
FONT_FOLDER="fonts"

# initial value
CUSTOM_FONTS=false
COMPILE_ALL_FOLDERS=false
COMPILE_ALL_KINDLE=false

# available options
OPTS=`getopt -o ao -l compile-all-ebooks,output-folder: -- "$@"`

# display usage prompt and quit if no arguments
[[ $# -eq 0 ]] && usage

eval set -- "$OPTS"

while [ "$1" != "" ]; do
    case "$1" in
        -a|--compile-all-ebooks)
            COMPILE_ALL_EBOOKS=true
            shift
            ;;
        -k|--also-generate-kindle-mobi)
            COMPILE_KINDLE_MOBI=true
            shift
            ;;
        -o|--output-folder)
            OUTPUT_FOLDER=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            usage
            ;;
    esac
done

# If COMPILE_ALL_FOLDERS is enabled, redefine EBOOK_FOLDER to a list of all folders in the current directory

echo "Generating EPUBs..."

# create an ebook for every ebook folder name passed in
for EBOOK_FOLDER
do
    # if folder doesn't exist, skip it and continue
    if [ ! -d "$EBOOK_FOLDER" ]; then
      echo "$EBOOK_FOLDER not found, skipping..."
      continue
    fi

    # check if fonts folder exists
    if [ -d "$EBOOK_FOLDER/$FONTS_FOLDER" ] ; then
      # check if fonts folder is empty
      HAVE_FONTS=$(ls -A "$EBOOK_FOLDER/$FONTS_FOLDER")
      if [ "$HAVE_FONTS" ]; then
        CUSTOM_FONTS=true
      else
        CUSTOM_FONTS=false
      fi
    fi

    # pandoc command must be run in the ebook's folder
    cd "$EBOOK_FOLDER"

    # format `metadata.yaml` for use by pandoc
    # 1) create a temporary copy of `metadata.yaml` with `.md` extension
    cp metadata.yaml metadata.md
    # 2) append "..." to last line of `metadata.md`
    sed -i '$ a ...' metadata.md

    # if/else structure: embed custom fonts or not
    if [ "$CUSTOM_FONTS" = true ] ; then
      # create pandoc arguments to embed all fonts in the folder
      LIST_OF_FONTS=""
      shopt -s nullglob
      for f in $FONT_FOLDER/*.ttf ; do
        LIST_OF_FONTS+="--epub-embed-font="
        LIST_OF_FONTS+=$f
        LIST_OF_FONTS+=" "
      done
      # append arguments to typical command
      pandoc metadata.md $PAGES_FOLDER/*.md -o "$EBOOK_FOLDER.epub" --toc $LIST_OF_FONTS
    else
      pandoc metadata.md $PAGES_FOLDER/*.md -o "$EBOOK_FOLDER.epub" --toc
    fi

    # Use kindlegen to create a MOBI file
    if [ "$COMPILE_KINDLE_MOBI" = true ] ; then
      kindlegen "$EBOOK_FOLDER.epub"
    fi

    # delete `metadata.md` (`metadata.yaml` not affected)
    rm metadata.md

    # return to original folder
    cd ..
done