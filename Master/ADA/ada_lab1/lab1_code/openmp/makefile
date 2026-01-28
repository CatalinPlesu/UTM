PARAMS = 5 6 7
THREADS = 1 2 4 8 16 32
OUTPUT = results_openmp.csv
SRC = lab1_openmp.cpp sha256.cpp
TARGET = lab1_openmp

all: run

run:
	echo "threads,parameter,time(ms)" > $(OUTPUT)
	for t in $(THREADS); do \
		echo "Compiling with $$t threads..."; \
		g++ -O3 -fopenmp -DNUM_THREADS=$$t $(SRC) -o $(TARGET); \
		for p in $(PARAMS); do \
			echo "Running with $$t threads and parameter $$p..."; \
			TIME_MS=`./$(TARGET) $$p | grep -Eo '[0-9]+ milliseconds' | grep -Eo '[0-9]+'`; \
			echo "$$t,$$p,$$TIME_MS" >> $(OUTPUT); \
		done \
	done

clean:
	rm -f $(TARGET) $(OUTPUT)
