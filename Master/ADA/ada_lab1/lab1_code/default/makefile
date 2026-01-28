PARAMS = 5 6 7
OUTPUT = results.csv

run:
	echo "parameter,time(ms)" > $(OUTPUT)
	for p in $(PARAMS); do \
		echo "Running with parameter $$p..."; \
		TIME_OUTPUT=`./lab1 $$p | grep -Eo '[0-9]+ milliseconds' | grep -Eo '[0-9]+'`; \
		echo "$$p,$$TIME_OUTPUT" >> $(OUTPUT); \
	done
