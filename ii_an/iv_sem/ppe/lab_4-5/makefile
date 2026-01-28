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

SRC = $(wildcard *.cpp)
SRC = source.cpp
# SRC = example6.cpp
EXE = Plesu_Catalin_PPE_lab_4-5.exe

all: compile run 

run:
	"$(DIR)$(EXE)"

compile: $(OS)

windows:
	$(CXX) $(SRC) $(CFLAGS) $(LINKER) $(LIBRARYES) -o $(EXE)

linux:
	$(CXX_LINUX) $(CFLAGS) $(SRC) $(LINKER) $(LIBRARYES) -o $(EXE) 

clean:
	rm $(EXE)
