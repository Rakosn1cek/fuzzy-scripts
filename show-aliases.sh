#!/bin/zsh

# Colors for better readability
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${YELLOW}--- YOUR CUSTOM TERMINAL ALIASES ---${NC}"
echo ""

# This command:
# 1. Grabs all lines starting with 'alias' from your .zshrc
# 2. Uses 'sed' to clean up the 'alias ' prefix and quotes
# 3. Uses 'column' to align everything perfectly
grep "^alias " ~/.zshrc | sed "s/alias //g" | sed "s/='/  ➜  /g" | sed "s/'//g" | column -t -s '➜' | while read -r line; do
    # Splitting the alias name from the command for coloring
    name=$(echo $line | awk '{print $1}')
    cmd=$(echo $line | cut -d' ' -f2-)
    printf "${CYAN}%-15s${NC} %s\n" "$name" "$cmd"
done

echo ""
echo -e "${YELLOW}------------------------------------${NC}"
