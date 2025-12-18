#!/bin/bash
# cdm_logic.sh - Optimized for MX Linux
# Logic script for the 'cdm' directory bookmark manager.
# This script outputs a command (e.g., 'cd /path/...') to STDOUT to be evaluated by the shell.

# --- Configuration ---
# Standard Linux location for the bookmarks file
BOOKMARKS_FILE="$HOME/.cd_bookmarks.txt"
FIELD_DELIMITER=':' # Format: NICKNAME:PATH

# Colors for terminal output
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_CYAN='\033[0;36m'
COLOR_RESET='\033[0m'
# ---------------------

# Function to display usage information to STDERR
_cdm_show_usage() {
    echo -e "${COLOR_CYAN}CDM - Directory Jumper (MX Linux)${COLOR_RESET}" >&2
    echo -e "Usage: cdm [jump] | cdm save <nickname> | cdm delete <nickname>" >&2
    echo -e "To jump, just type 'cdm' without arguments." >&2
}

# Function to implement the FZF jump logic
_cdm_jump_menu() {
    if ! command -v fzf &> /dev/null; then
        echo -e "${COLOR_RED}Error: fzf not found. Please install it: sudo apt install fzf${COLOR_RESET}" >&2
        return 1
    fi
    
    if [ ! -f "$BOOKMARKS_FILE" ] || [ ! -s "$BOOKMARKS_FILE" ]; then
        echo -e "${COLOR_YELLOW}No bookmarks found. Save one first: cdm save <name>${COLOR_RESET}" >&2
        return 1
    fi

    local RAW_OUTPUT
    local FULL_SELECTED_LINE
    local JUMP_PATH

    # 1. Prepare input for fzf and capture selection
    RAW_OUTPUT=$(
        cat "$BOOKMARKS_FILE" | 
        tr -dc '[:print:][:space:]\n' |
        grep -vE '^\s*#|^\s*$' |
        awk -F"$FIELD_DELIMITER" '{ printf "%-15s | %s\n", $1, $2 }' |
        fzf --prompt="JUMP TO > " \
            --ansi \
            --reverse \
            --header="Select a bookmark to jump to" \
            --preview-window=down:1:wrap \
            --preview='echo "Target Path: {2}"'
    )
    
    # 2. Extract path from the fzf selection (the part after the pipe)
    if [ -n "$RAW_OUTPUT" ]; then
        # Selection format is "nickname | path"
        JUMP_PATH=$(echo "$RAW_OUTPUT" | awk -F ' | ' '{print $NF}' | xargs)

        if [ -d "$JUMP_PATH" ]; then
            # Output the CD command for the parent shell to eval
            echo "cd \"$JUMP_PATH\""
            echo -e "${COLOR_GREEN}Jumped to: $JUMP_PATH${COLOR_RESET}" >&2
        else
            echo -e "${COLOR_RED}Error: Path not found: $JUMP_PATH${COLOR_RESET}" >&2
            return 1
        fi
    fi
}

# Main function to handle commands
_cdm_main() {
    local COMMAND="$1"
    local NICKNAME="$2"
    local CURRENT_PATH="$PWD"

    # Default action: Jump
    if [ $# -eq 0 ] || [ "$COMMAND" = "jump" ]; then
        _cdm_jump_menu
        return $?
    fi

    case "$COMMAND" in
        save)
            if [ -z "$NICKNAME" ]; then
                echo -e "${COLOR_RED}Error: 'save' requires a nickname.${COLOR_RESET}" >&2
                return 1
            fi
            
            # Remove existing nickname if it exists
            touch "$BOOKMARKS_FILE"
            grep -vE "^$NICKNAME:" "$BOOKMARKS_FILE" > "${BOOKMARKS_FILE}.tmp"
            echo "$NICKNAME:$CURRENT_PATH" >> "${BOOKMARKS_FILE}.tmp"
            mv "${BOOKMARKS_FILE}.tmp" "$BOOKMARKS_FILE"
            
            echo -e "${COLOR_GREEN}✔ Saved '$NICKNAME' -> $CURRENT_PATH${COLOR_RESET}" >&2
            ;;

        delete)
            if [ -z "$NICKNAME" ]; then
                echo -e "${COLOR_YELLOW}Usage: cdm delete <nickname>${COLOR_RESET}" >&2
                echo "Current bookmarks:" >&2
                cat "$BOOKMARKS_FILE" >&2
                return 1
            fi

            if grep -qE "^$NICKNAME:" "$BOOKMARKS_FILE"; then
                grep -vE "^$NICKNAME:" "$BOOKMARKS_FILE" > "${BOOKMARKS_FILE}.tmp"
                mv "${BOOKMARKS_FILE}.tmp" "$BOOKMARKS_FILE"
                echo -e "${COLOR_GREEN}✔ Deleted bookmark: $NICKNAME${COLOR_RESET}" >&2
            else
                echo -e "${COLOR_RED}Error: Nickname '$NICKNAME' not found.${COLOR_RESET}" >&2
            fi
            ;;

        *)
            _cdm_show_usage
            return 1
            ;;
    esac
}

_cdm_main "$@"
