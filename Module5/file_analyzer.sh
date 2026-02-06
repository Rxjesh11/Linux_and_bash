#!/bin/bash

# Here Document – Help Menu

show_help() {
cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Recursively search a directory
  -f <file>        Search keyword in a specific file
  -k <keyword>     Keyword to search
  --help           Display this help menu

Examples:
  $0 -d logs -k error
  $0 -f script.sh -k TODO
EOF
}

#Error logging(Redirection & handling)
ERROR_LOG="errors.log"

log_error() {
    echo "[$(date)] $1" | tee -a "$ERROR_LOG" >&2
}

# Handle --help Menu
for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        show_help
        exit 0
    fi
done

#getopts – Command-line arguments
SEARCH_DIR=""
SEARCH_FILE=""
KEYWORD=""

while getopts ":d:f:k:" opt; do
    case "$opt" in
        d) SEARCH_DIR="$OPTARG" ;;
        f) SEARCH_FILE="$OPTARG" ;;
        k) KEYWORD="$OPTARG" ;;
        \?)
            log_error "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            log_error "Option -$OPTARG requires an argument"
            exit 1
            ;;
    esac
done

#Regular Expression Validation
valid_keyword_regex='^[a-zA-Z0-9_]+$'

if [[ -z "$KEYWORD" || ! "$KEYWORD" =~ $valid_keyword_regex ]]; then
    log_error "Invalid or empty keyword"
    exit 1
fi

#Argument count check 
if [[ $# -eq 0 ]]; then
    log_error "No arguments provided. Use --help"
    exit 1
fi

# Special parameters
echo "Script name       : $0"
echo "Total arguments   : $#"
echo "All arguments     : $@"

#Recursive function
recursive_search() {
    local dir="$1"
    local keyword="$2"

    for item in "$dir"/*; do
        if [[ -f "$item" ]]; then
            if grep -q "$keyword" "$item" 2>>"$ERROR_LOG"; then
                echo "Match found in: $item"
            fi
        elif [[ -d "$item" ]]; then
            recursive_search "$item" "$keyword"
        fi
    done
}

#Directory search 
if [[ -n "$SEARCH_DIR" ]]; then
    if [[ ! -d "$SEARCH_DIR" ]]; then
        log_error "Directory not found: $SEARCH_DIR"
        exit 1
    fi

    echo "Searching directory '$SEARCH_DIR' for '$KEYWORD'..."
    recursive_search "$SEARCH_DIR" "$KEYWORD"
    echo "Exit status: $?"   # STEP 3: $?
fi

# Here String – File search
if [[ -n "$SEARCH_FILE" ]]; then
    if [[ ! -f "$SEARCH_FILE" ]]; then
        log_error "File not found: $SEARCH_FILE"
        exit 1
    fi

    echo "Searching file '$SEARCH_FILE' for '$KEYWORD'..."
    grep "$KEYWORD" <<< "$(cat "$SEARCH_FILE")"
    echo "Exit status: $?"   # STEP 3: $?
fi

exit 0
