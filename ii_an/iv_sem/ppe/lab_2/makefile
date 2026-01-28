ifeq ($(OS), Windows_NT)
	OS = windows
	DIR = ".\"
else
	OS = linux
	DIR = "./"
endif

CXX = g++
CXX_LINUX = i686-w64-mingw32-g++ 
CFLAGS = -ggdb -Wall -O3
LINKER = -static-libstdc++ -static-libgcc -static
LIBRARYES = -mwindows -lgdiplus

SRCS = $(wildcard *.cpp)
EXE = Plesu_Catalin_GC_lab_2.exe

all: compile run 

run:
	"$(DIR)$(EXE)"

compile: $(OS)

windows:
	$(CXX) $(SRCS) $(CFLAGS) $(LINKER) $(LIBRARYES) -o $(EXE)

linux:
	$(CXX_LINUX) $(CFLAGS) $(SRCS) $(LINKER) $(LIBRARYES) -o $(EXE) 

clean:
	rm $(EXE)
