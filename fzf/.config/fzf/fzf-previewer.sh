#!/usr/bin/env bash

file="${1/#\~/$HOME}"

if [[ $(file -b "$file") == directory ]]; then
    # tree -C "$file"
    eza -la --color=always --icons -g --group-directories-first "$file"
    exit
fi

mime=$(file --dereference --brief --mime-type "$file")

if [[ $mime =~ \-binary ]]; then
    file "$file"
    exit
fi

image_previewer() {
    printf "Image preview is not supported"
}

if [[ $mime =~ image/ ]]; then
    echo "Resolution: $(identify -format "%w×%h" "$file")"
    image_previewer "$file"
    exit
fi

# Video can be previewed by previewing its thumbnail
if [[ $mime =~ video/|audio/ ]]; then
    dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$file")
    echo "Dimensions: $dimensions"
    image_previewer ""
    exit
fi

(bat --color=always --style=numbers "$file" \
    || highlight --out-format truecolor --style darkplus --force --line-numbers "$file" \
    || cat "$file") | head -200 \
    || echo -e " No preview supported for the current selection:\n\n $file"
