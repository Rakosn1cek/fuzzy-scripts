🛠️ Linux Productivity Suite

A collection of automation scripts for MX Linux / XFCE and Termux to streamline terminal workflow, documentation, and file management.

📂 1. Automated File Organizer (organizer.py)

A background service that monitors ~/Downloads and sorts files into system folders (Pictures, Documents, etc.) automatically based on file extensions.

Run: nohup python3 ~/Scripts/organizer.py > /dev/null 2>&1 &

Features: Real-time sorting, XFCE desktop notifications via notify-send.

📋 2. CLI Snippet Manager (snip.py)

Save and retrieve code snippets or terminal commands instantly using the system clipboard.

Save: Copy text to clipboard, then run snip save <name>

Retrieve: Run snip get <name> (copies content back to clipboard)

Requires: xclip (for X11/Desktop)

🎞️ 3. Screensaver Utility (screensaver.sh)

A robust, boxed-menu interface to launch different cmatrix digital rain styles.

Run: zsh ~/Scripts/screensaver.sh

Features: ASCII-boxed menu, multiple color/speed presets, automatic environment detection (Termux vs. Linux Desktop).

Requires: cmatrix

⌨️ 4. Alias Cheat Sheet (show-aliases.sh)

An interactive, fuzzy-searchable viewer for your custom Zsh aliases.

Run: help-me

Features: Scans ~/.zshrc, provides fuzzy search, and executes selected alias.

Requires: fzf

🛠 Setup & Installation

1. Clone the repository

mkdir -p ~/Scripts
git clone [https://github.com/Rakosn1cek/fuzzy-scripts.git](https://github.com/Rakosn1cek/fuzzy-scripts.git) ~/Scripts


2. Install Dependencies

Depending on your environment, install the following:

For MX Linux / Desktop:

sudo apt update
sudo apt install xclip cclip cmatrix fzf
pip install --user watchdog


For Termux:

pkg install cmatrix fzf


3. Add Zsh Aliases

Add these to the bottom of your ~/.zshrc for quick access:

# Tool Aliases
alias snip='python3 ~/Scripts/snip.py'
alias matrix='zsh ~/Scripts/screensaver.sh'
alias help-me='zsh ~/Scripts/show-aliases.sh'

# Organizer Management
alias org-check='pgrep -fl organizer.py'
alias org-stop='pkill -f organizer.py'
alias org-edit='nano ~/Scripts/organizer.py'


📜 License

MIT License - Feel free to use and modify!
