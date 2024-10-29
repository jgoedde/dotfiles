#!/bin/bash
# Maximum length for artist and title before truncation
MAX_LENGTH=22

status=$(playerctl status 2>/dev/null)
if [[ "$status" == "Playing" ]]; then
    title=$(playerctl metadata title)
    artist=$(playerctl metadata artist)

    # Truncate title and artist if they exceed MAX_LENGTH
    if [[ ${#title} -gt $MAX_LENGTH ]]; then
        title="${title:0:$MAX_LENGTH}…"
    fi
    if [[ ${#artist} -gt $MAX_LENGTH ]]; then
        artist="${artist:0:$MAX_LENGTH}…"
    fi

    echo "<txt>$artist - $title 🎵</txt>"
else
    echo ""
fi

