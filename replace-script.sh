#!/bin/bash
ICONS_PATH=/usr/share/icons/candy-icons/apps/scalable 
SNAP_PATH=/var/lib/snapd/desktop/applications/

files=$(find $SNAP_PATH -name "*.desktop" 2>/dev/null)
for file in $files
do
    base_name=$(basename $file | cut -d "_" -f 1)
    poss=$(ls $ICONS_PATH | grep -E "$base_name")
    echo "===================================="
    echo $base_name
    icon="default.svg"
    if [ -z "$poss" ]; then
        echo "No matching icon found for $base_name"
        case $base_name in
            "snap-store")
                icon="software-store.svg"
                ;;
            "dbeaver-ce")
                icon="dbeaver.svg"
                ;;
            *)
                echo "No alternative icon."
                ;;
        esac
    elif [ -f "$ICONS_PATH/$base_name.svg" ]; then
        icon="$base_name.svg"
    else
        icon=$(echo $poss | head -n 1)
    fi
    echo $icon
    sed -i "s|Icon=.*|Icon=$icon|" "$file"
done
