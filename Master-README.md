🛠️ Linux Productivity Suite

A collection of automation scripts for MX Linux / XFCE to streamline terminal workflow and file management.

📂 1. Automated File Organizer (organizer.py)

A background service that monitors ~/Downloads and sorts files into system folders (Pictures, Documents, etc.) automatically.

Run: nohup python3 ~/Scripts/organizer.py > /dev/null 2>&1 &

Features: Real-time sorting, XFCE desktop notifications.

📋 2. CLI Snippet Manager (snip.py)

Save and retrieve code snippets or terminal commands instantly via the clipboard.

Save: Copy text to clipboard, then run snip save <name>

Retrieve: Run snip get <name> (copies content back to clipboard)

Requires: sudo apt install xclip

⌨️ 3. Alias Cheat Sheet (show-aliases.sh)

A clean, color-coded viewer for your custom Zsh aliases.

Run: help-me (once alias is set)

Features: Scans ~/.zshrc and formats output for easy reading.

🛠 Setup

1. Clone the repo

git clone [https://github.com/Rakosn1cek/fuzzy-scripts.git](https://github.com/Rakosn1cek/fuzzy-scripts.git) ~/Scripts


2. Install Dependencies

pip install --user watchdog
sudo apt install xclip


3. Add Zsh Aliases

Add these to the bottom of your ~/.zshrc:

# Tool Aliases
alias snip='python3 ~/Scripts/snip.py'
alias help-me='zsh ~/Scripts/show-aliases.sh'

# Organizer Management
alias org-check='pgrep -fl organizer.py'
alias org-stop='pkill -f organizer.py'
alias org-edit='nano ~/Scripts/organizer.py'


📜 License

MIT - Free to use and modify.