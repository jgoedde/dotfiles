#!/usr/bin/env bash
# Rofi script mode for trigger-based web search.
# Power user: type "g foo" → Enter → Google (ROFI_RETV=2)
# Browse:     select engine → type query → Enter (two-step)

declare -A ENGINES=(
    ["g"]="https://www.google.com/search?q={q}"
    ["d"]="https://www.dwds.de/wb/{q}"
    ["dwrite"]="https://www.deepl.com/en/write#en-US/{q}"
    ["deen"]="https://www.deepl.com/en/translator#de/en/{q}"
    ["ende"]="https://www.deepl.com/en/translator#en/de/{q}"
    ["gh"]="https://github.com/search?utf8=%E2%9C%93&q={q}"
    ["gmaps"]="https://www.google.com/maps/search/{q}/"
    ["gm"]="https://www.google.com/maps/search/{q}/"
    ["y"]="https://www.youtube.com/results?search_query={q}"
    ["yt"]="https://www.youtube.com/results?search_query={q}"
)

ENGINES_ORDERED=(
    "Google|g"
    "DWDS|d"
    "DeepL DE→EN|deen"
    "DeepL EN→DE|ende"
    "DeepL Write|dwrite"
    "GitHub|gh"
    "YouTube|y"
    "Google Maps|gmaps"
)

urlencode() {
    python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
}

open_url() {
    local trigger="$1" query="$2"
    local url="${ENGINES[$trigger]//\{q\}/$(urlencode "$query")}"
    xdg-open "$url" &
}

parse_and_open() {
    local input="$1"
    if [[ "$input" =~ ^([a-zA-Z]+)[[:space:]]+(.*) ]]; then
        local trigger="${BASH_REMATCH[1]}" query="${BASH_REMATCH[2]}"
        if [[ -n "${ENGINES[$trigger]}" ]]; then
            open_url "$trigger" "$query"
            return
        fi
    fi
    open_url "g" "$input"
}

case "${ROFI_RETV}" in
    0)
        for entry in "${ENGINES_ORDERED[@]}"; do
            printf '%s  (%s)\n' "${entry%%|*}" "${entry##*|}"
        done
        ;;
    1)
        # Engine selected from list — switch to query prompt
        if [[ "$1" =~ \(([a-zA-Z]+)\)$ ]]; then
            printf '\x00prompt\x1f%s\n' "${1%%  (*}"
            printf '\x00data\x1f%s\n' "${BASH_REMATCH[1]}"
        fi
        # No items output → empty list → next Enter = ROFI_RETV=2
        ;;
    2)
        if [[ -n "$ROFI_DATA" ]]; then
            open_url "$ROFI_DATA" "$1"
        else
            parse_and_open "$1"
        fi
        ;;
esac
