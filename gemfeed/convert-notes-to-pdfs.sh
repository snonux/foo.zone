#!/usr/bin/env bash

convert () {
  find . -name \*.note \
    | while read -r note; do
        echo supernote-tool convert -a -t pdf "$note" "${note/.note/.pdf}"
        supernote-tool convert -a -t pdf "$note" "${note/.note/.pdf}.tmp"
        mv "${note/.note/.pdf}.tmp" "${note/.note/.pdf}"
        du -hs "$note" "${note/.note/.pdf}"
        echo
      done
}

# Mage the PDFs available on my Phone as well
copy () {
  if [ ! -d ~/Documents/Supernote ]; then
    echo "Directory ~/Documents/Supernote does not exist, skipping"
    exit 1
  fi

  rsync -delete -av --include='*/' --include='*.pdf' --exclude='*' . ~/Documents/Supernote/
  echo This was copied from $(pwd) so dont edit manually >~/Documents/Supernote/README.txt
}

convert
copy
