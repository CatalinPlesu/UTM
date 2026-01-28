# run:
# 	ml /c /Zd /coff $(src).asm
# 	link /SUBSYSTEM:CONSOLE $(src).obj
 	# .\$(src).exe
src = x32.asm
ml_flags = /c /nologo /Sg /WX /Zi /Fo"x32.obj" /Fl"Project.lst" /I "c:\Irvine" /W3 /errorReport:prompt  /Ta
run:
	WINEPREFIX=~/.wine-wow wine '/home/catalin/.PlayOnLinux/wineprefix/MASM/drive_c/masm32/bin/ml.exe' $(ml_flags) $(src)

# ml.exe /c /nologo /Sg /WX /Zi /Fo"Debug\x32.obj" /Fl"Project.lst" /I "c:\Irvine" /W3 /errorReport:prompt  /Ta
