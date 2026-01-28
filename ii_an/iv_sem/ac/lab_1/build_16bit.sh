#!/bin/bash
set -e # Stop on errors

# Get the path to the file without a .asm extension
FILENAME="$(basename "$1")"
EXTENSION="${FILENAME##*.}"
shopt -s nocasematch # String case-insensitive comparison
if [[ "$EXTENSION" = "asm" ]]; then
    FILENAME="${FILENAME%.*}" # Remove extension
fi
FILEPATH="$(dirname "$1")/$FILENAME"

shopt -s expand_aliases
# WINEDEBUG flag hides the fixme:ntdll:NtQuerySystemInformation warning (which can be safely ignored)
alias wine_masm="WINEDEBUG=fixme-all WINEARCH=win32 WINEPREFIX=~/.local/share/wineprefixes/masm/ wine"

echo "> Assembling..."
# ML="ml -Fl"$FILEPATH".lst -nologo -c -coff -Zi $FILEPATH.asm" 
# ML="ml /nologo -c -Fl"$FILEPATH".lst -Zi $FILEPATH.asm" 
ML="ml -Fl"$FILEPATH".lst -nologo -c -Zi $FILEPATH.asm" 

# ml does not output anything if run directly
# if it fails, run in CMD to see errors (& trim out fluff)
wine_masm $ML || (
    echo $ML | wine_masm cmd | head -n -2 | tail -n +4
    exit 1
)

echo "> Linking..."
# wine_masm link16 "$FILEPATH.obj",,NUL,Irvine16 /CODEVIEW
echo | wine_masm link16 "$FILENAME".obj
 
echo "> Running..."
echo
wine_masm "$FILEPATH.exe"
