import os
import time
import shutil
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# --- CONFIGURATION ---
# The folder to watch
WATCH_DIR = os.path.expanduser("~/Downloads")

# Mapping of file extensions to ACTUAL system folders
# We use os.path.expanduser to ensure it points to /home/Rakosn1cek/...
DEST_DIRS = {
    os.path.expanduser("~/Documents"): [".pdf", ".docx", ".txt", ".pptx", ".csv", ".xlsx"],
    os.path.expanduser("~/Pictures"): [".jpg", ".jpeg", ".png", ".gif", ".svg", ".webp"],
    os.path.expanduser("~/Music"): [".mp3", ".wav", ".flac", ".m4a"],
    os.path.expanduser("~/Videos"): [".mp4", ".mov", ".avi", ".mkv"],
    os.path.expanduser("~/Downloads/Archives"): [".zip", ".tar", ".gz", ".rar", ".7z"],
    os.path.expanduser("~/Documents/Code"): [".py", ".js", ".html", ".css", ".sh", ".json", ".md"]
}

class MoveHandler(FileSystemEventHandler):
    def on_modified(self, event):
        for filename in os.listdir(WATCH_DIR):
            # Skip if it's a directory
            if os.path.isdir(os.path.join(WATCH_DIR, filename)):
                continue
                
            file_ext = os.path.splitext(filename)[1].lower()
            
            for dest_path, extensions in DEST_DIRS.items():
                if file_ext in extensions:
                    self.move_file(filename, dest_path)

    def move_file(self, filename, dest_path):
        # Create destination folder if it doesn't exist (e.g., ~/Documents/Code)
        if not os.path.exists(dest_path):
            os.makedirs(dest_path)
        
        source = os.path.join(WATCH_DIR, filename)
        destination = os.path.join(dest_path, filename)
        
        # Move the file if it doesn't exist at destination
        if not os.path.exists(destination):
            try:
                shutil.move(source, destination)
                # Success Notification
                subprocess.run([
                    "notify-send", 
                    "-t", "4000", 
                    "File Organized", 
                    f"Moved {filename} to {os.path.basename(dest_path)}"
                ])
                print(f"Moved: {filename} -> {dest_path}")
            except Exception as e:
                print(f"Error: {e}")

if __name__ == "__main__":
    event_handler = MoveHandler()
    observer = Observer()
    observer.schedule(event_handler, WATCH_DIR, recursive=False)
    
    print(f"--- Monitoring Started on {WATCH_DIR} ---")
    observer.start()
    try:
        while True:
            time.sleep(10)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
