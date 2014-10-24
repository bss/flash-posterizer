#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NAME="FlashPosterizer"
AUTHOR="Bo Stendal Sorensen"
IDENTIFIER="org.bss.FlashPosterizer"
ICON="$SCRIPT_DIR/icon.icns"
VALID_FILES="fla"
ZIP_LIB="$SCRIPT_DIR/rubyzip-1.1.0"
SCRIPT="$SCRIPT_DIR/FlashPosterizer.rb"
DESTINATION="$SCRIPT_DIR/FlashPosterizer.app"

/usr/local/bin/platypus -D  -i "$ICON"  -Q "$ICON"  -a "$NAME"  -o "Droplet" -p "/usr/bin/ruby" -X "$VALID_FILES" -f "$ZIP_LIB" -u "$AUTHOR" -I "$IDENTIFIER" "$SCRIPT" "$DESTINATION"
