# Makefile. If you change it, remember than in makefiles multiple spaces
# ARE NOT EQUIVALENT to tabs. The line after a rule starts with a tab!

#Add any executable you want to be created here.
EXECUTABLES	= sobel_orig

#This is the compiler to use
CC = gcc

#These are the flags passed to the compiler. Change accordingly
CFLAGS = -Wall -O0

#These are the flags passed to the linker. Nothing in our case
LDFLAGS = -lm


# make all will create all executables
all: $(EXECUTABLES)

# This is the rule to create any executable from the corresponding .c 
# file with the same name.
%: %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

# make clean will remove all executables, jpg files and the 
# output of previous executions.
clean:
	rm -f $(EXECUTABLES) *.jpg output_sobel.grey

# make image will create the output_sobel.jpg from the output_sobel.grey. 
# Remember to change this rule if you change the name of the output file.
image: output_sobel.grey
	convert -depth 8 -size 4096x4096 GRAY:output_sobel.grey output_sobel.jpg 

# New rule to run the executable 12 times and capture time and PSNR
# make run_experiment prefix=test
run_experiment: $(EXECUTABLES)
	@if [ -z "$(prefix)" ]; then \
		echo "Error: Please provide a 'prefix' argument for the CSV files."; \
		exit 1; \
	fi
	@rm -f $(prefix)_run.csv # Clean up previous run CSVs
	@echo "Total time,PSNR" > $(prefix)_run.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_orig); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)_run.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)_run.csv; \
		fi; \
	done; \
	@echo "Run completed. Results saved in $(prefix)_run.csv"

# make stats prefix=test
stats:
	@if [ -z "$(prefix)" ]; then \
		echo "Error: Please provide a 'prefix' argument for the CSV files."; \
		exit 1; \
	fi
	python3 calculate_stats.py $(prefix)