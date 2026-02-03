#!/bin/bash

SOURCE_DIR="$1"
BACKUP_DIR="$2"
EXTENSION="$3"
echo
echo "The source directory is $SOURCE_DIR"
echo "The backup directory is $BACKUP_DIR"
echo "The files to be searched is $EXTENSION files"
echo
if [ "$#" -ne 3 ]; then
	echo "Usage: $0 <source_dir> <backup_dir> <file_extension>"
	exit 1
fi

FILES=("$SOURCE_DIR"/*"$EXTENSION")
if [ ! -e "${FILES[0]}" ]; then
	echo "No files found with extension $EXTENSION"
	exit 0
echo "Number of matched files: ${#FILES[@]}"
echo
fi

export BACKUP_COUNT=0
TOTAL_SIZE=0


echo "Files to be backed up:"
for file in "${FILES[@]}"; do
  size=$(stat -c %s "$file")
  echo "$(basename "$file") - $size bytes"
  echo
done


if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR" || {
    echo "Failed to create backup directory"
    exit 1
  }
fi

for file in "${FILES[@]}"; do
  filename=$(basename "$file")
  dest="$BACKUP_DIR/$filename"

  if [ -e "$dest" ]; then
    if [ "$file" -nt "$dest" ]; then
      cp "$file" "$dest"
    else
      continue
    fi
  else
    cp "$file" "$dest"
  fi

  size=$(stat -c %s "$file")
  TOTAL_SIZE=$((TOTAL_SIZE + size))
  BACKUP_COUNT=$((BACKUP_COUNT + 1))
done


REPORT="$BACKUP_DIR/backup_report.log"

{
  echo "Backup Summary Report"
  echo "Total files backed up : $BACKUP_COUNT"
  echo "Total size backed up  : $TOTAL_SIZE bytes"
  echo "Backup directory      : $BACKUP_DIR"
  echo "Date                  : $(date)"
} | tee "$REPORT"

echo
echo "Backup completed successfully"
echo "Report saved at: $BACKUP_DIR/backup_report.log"
