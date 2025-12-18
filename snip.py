import json
import os
import sys
import subprocess

# Path to the snippets storage file
STORAGE_FILE = os.path.expanduser("~/Scripts/snippets.json")

def load_snippets():
    if not os.path.exists(STORAGE_FILE):
        return {}
    with open(STORAGE_FILE, 'r') as f:
        try:
            return json.load(f)
        except json.JSONDecodeError:
            return {}

def save_snippets(snippets):
    with open(STORAGE_FILE, 'w') as f:
        json.dump(snippets, f, indent=4)

def copy_to_clipboard(text):
    # Uses xclip for X11/XFCE compatibility
    try:
        process = subprocess.Popen(['xclip', '-selection', 'clipboard'], stdin=subprocess.PIPE)
        process.communicate(input=text.encode('utf-8'))
        print("📋 Copied to clipboard!")
    except FileNotFoundError:
        print("❌ Error: 'xclip' not found. Install it with: sudo apt install xclip")

def main():
    snippets = load_snippets()
    
    if len(sys.argv) < 2:
        print("Usage:")
        print("  snip save <name>    - Save clipboard content as a snippet")
        print("  snip get <name>     - Copy a snippet to clipboard")
        print("  snip list           - Show all saved snippets")
        print("  snip del <name>     - Delete a snippet")
        return

    command = sys.argv[1].lower()

    if command == "save" and len(sys.argv) > 2:
        name = sys.argv[2]
        # Get content from clipboard to save
        try:
            content = subprocess.check_output(['xclip', '-selection', 'clipboard', '-o']).decode('utf-8')
            snippets[name] = content
            save_snippets(snippets)
            print(f"✅ Saved snippet: {name}")
        except Exception:
            print("❌ Error: Could not read clipboard. Make sure you have something copied!")

    elif command == "get" and len(sys.argv) > 2:
        name = sys.argv[2]
        if name in snippets:
            copy_to_clipboard(snippets[name])
        else:
            print(f"❌ Snippet '{name}' not found.")

    elif command == "list":
        if not snippets:
            print("📭 No snippets saved yet.")
        else:
            print("📜 Your Snippets:")
            for s in snippets:
                print(f"  - {s}")

    elif command == "del" and len(sys.argv) > 2:
        name = sys.argv[2]
        if name in snippets:
            del snippets[name]
            save_snippets(snippets)
            print(f"🗑️ Deleted: {name}")
        else:
            print(f"❌ Snippet '{name}' not found.")
    else:
        print("Invalid command or missing arguments.")

if __name__ == "__main__":
    main()
