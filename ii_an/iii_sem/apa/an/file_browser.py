import sys
import subprocess

def open_file_browser(directory):
    if sys.platform=='win32':
        subprocess.Popen(['start', directory], shell= True)

    elif sys.platform=='darwin':
        subprocess.Popen(['open', directory])

    else:
        try:
            subprocess.Popen(['xdg-open', directory])
        except OSError:
            print("You shoud check the'", directory,
                    "'folder, but I can't open it for you")
            pass

if __name__ == "__main__":
    open_file_browser("output")

