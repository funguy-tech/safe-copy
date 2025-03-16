#!/bin/bash

# Use environment variables with defaults if not provided
WATCH_DIR="/ftp"
DEST_DIR="/dest"
OWNER="${OWNER:-newuser:newgroup}"
PERMS="${PERMS:-0644}"
STABLE_INTERVAL="${STABLE_INTERVAL:-5}"

echo "Starting file processor with configuration:"
echo "  WATCH_DIR: ${WATCH_DIR}"
echo "  DEST_DIR: ${DEST_DIR}"
echo "  OWNER: ${OWNER}"
echo "  PERMS: ${PERMS}"
echo "  STABLE_INTERVAL: ${STABLE_INTERVAL} seconds"

# Monitor directory for new/closed files using inotifywait
inotifywait -m -e close_write,moved_to "$WATCH_DIR" --format "%f" | while read FILENAME; do
    FILE="$WATCH_DIR/$FILENAME"
    # Process only PDFs (adjust the filter as needed)
    if [[ "$FILE" != *.pdf ]]; then
        echo "Skipping non-PDF file: $FILENAME"
        continue
    fi

    # Check file size stabilization
    SIZE1=$(stat -c%s "$FILE")
    sleep "$STABLE_INTERVAL"
    SIZE2=$(stat -c%s "$FILE")
    
    if [ "$SIZE1" -eq "$SIZE2" ]; then
        echo "Processing file: $FILENAME"
        mv "$FILE" "$DEST_DIR"
        chown "$OWNER" "$DEST_DIR/$(basename "$FILE")"
        chmod "$PERMS" "$DEST_DIR/$(basename "$FILE")"
        echo "Processed $FILENAME successfully."
    else
        echo "File $FILENAME is still being written to. Skipping."
    fi
done
