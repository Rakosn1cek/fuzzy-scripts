#!/bin/zsh

# Description: A utility script to install and run the 'cmatrix' 
# screensaver effect, providing multiple style options.

# Function to check and install cmatrix
check_installation() {
    if ! command -v cmatrix &> /dev/null; then
        echo "Cmatrix is not installed."
        read "confirm?Do you want to install it now? (y/n): "
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            # Check if using Termux (pkg) or Linux (sudo apt)
            if command -v pkg &> /dev/null; then
                pkg install cmatrix -y
            else
                sudo apt update && sudo apt install cmatrix -y
            fi
            
            if ! command -v cmatrix &> /dev/null; then
                echo "Error: Cmatrix installation failed." >&2
                return 1
            fi
            echo "Cmatrix installed successfully!"
        else
            echo "Cmatrix is required. Aborting." >&2
            return 1
        fi
    fi
    return 0
}

# Function to display the selection menu and run the screensaver
run_screensaver() {
    while true; do
        # Clear screen to keep the "instance" look clean
        clear

        # Print the boxed menu using standard ASCII characters
        echo "+------------------------------------------+"
        echo "|         SCREENSAVER STYLE MENU           |"
        echo "+------------------------------------------+"
        echo "|  1) Matrix Rain (Default)                |"
        echo "|  2) Binary Rain (B&W)                    |"
        echo "|  3) Random Colors                        |"
        echo "|  4) Fast & Intense                       |"
        echo "|  5) Quit Screensaver                     |"
        echo "+------------------------------------------+"
        echo ""
        
        # Request input
        echo -n "Selection [1-5]: "
        read choice

        case $choice in
            1)
                ARGS="-u 10 -C green"
                break
                ;;
            2)
                ARGS="-b -u 10 -C white"
                break
                ;;
            3)
                ARGS="-r -u 10"
                break
                ;;
            4)
                ARGS="-u 20 -C green"
                break
                ;;
            5)
                echo "Exiting screensaver utility."
                return 0
                ;;
            *)
                echo "Invalid selection. Press Enter to try again..."
                read
                continue
                ;;
        esac
    done

    echo "\n--- Starting Screensaver ---"
    echo "(Press CTRL+C to stop and return to menu)"
    sleep 1
    
    # Execute cmatrix with the selected arguments
    # ${=ARGS} enables word splitting in Zsh
    cmatrix ${=ARGS}
    
    # Reset terminal state to fix colors/cursor after cmatrix
    reset
    
    # Optional: loop back to menu after closing cmatrix
    run_screensaver
}

# --- Main Execution ---
if check_installation; then
    run_screensaver
fi
