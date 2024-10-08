#!/bin/bash
ICONS_PATH=/usr/share/icons/candy-icons/apps/scalable
SNAP_PATH=/var/lib/snapd/desktop/applications/
LOCAL_PATH=~/.local/share/applications

declare -A alt_icons=(
    ["snap-store"]="software-store.svg"
    ["dbeaver-ce"]="dbeaver.svg"
    ["p7zip-desktop"]="p7zip.svg"
    ["powershell"]="bash.svg"
)

files=$(find $SNAP_PATH -name "*.desktop" 2>/dev/null)
for file in $files; do
    bname=$(basename "$file")
    base_name=$(echo "$bname" | cut -d "_" -f 1)
    poss=$(ls $ICONS_PATH | grep -E "$base_name")
    echo "===================================="
    echo "$base_name"
    icon=""

    if [ -z "$poss" ]; then
        echo "No matching icon found for $base_name"
        if [ -n "${alt_icons[$base_name]}" ]; then
            icon=${alt_icons[$base_name]}
        fi
    elif [ -f "$ICONS_PATH/$base_name.svg" ]; then
        icon="$base_name.svg"
    else
        icon=$(echo "$poss" | head -n 1)
    fi

    if [ -z "$icon" ]; then
        continue
    fi

    echo "$icon"
    sed "s|Icon=.*|Icon=$icon|" "$file" >"$LOCAL_PATH/$bname"
done
