# Makefile. If you change it, remember than in makefiles multiple spaces
# ARE NOT EQUIVALENT to tabs. The line after a rule starts with a tab!

#Add any executable you want to be created here.
EXECUTABLES	= sobel_orig sobel_Common_Subexpression_Elimination sobel_Function_Inlining sobel_Loop_Fusion sobel_Loop_Interchange sobel_Loop_Invariant_code_motion sobel_Loop_Unrolling sobel_Strength_Reduction sobel_KAPA

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
#	@if [ -z "$(prefix)" ]; then \
#		echo "Error: Please provide a 'prefix' argument for the CSV files."; \
#		exit 1; \
#	fi
#	ORIGINAL
	@rm -f $(prefix)original.csv # Clean up previous run CSVs
	@echo "Total time,PSNR" > $(prefix)original.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_orig); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)original.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)original.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)original
	@echo "Run completed. Results saved in $(prefix)original.csv"
#	################################################################################################
#	LOOP INTERCHANGE
	@echo "Total time,PSNR" > $(prefix)loop_interchange.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_Loop_Interchange); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)loop_interchange.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)loop_interchange.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)loop_interchange
	@echo "Run completed. Results saved in $(prefix)loop_interchange.csv"
#	################################################################################################
# 	LOOP UNROLLING
	@echo "Total time,PSNR" > $(prefix)Loop_Unrolling.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_Loop_Unrolling); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)Loop_Unrolling.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)Loop_Unrolling.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)Loop_Unrolling
	@echo "Run completed. Results saved in $(prefix)Loop_Unrolling.csv"
#	################################################################################################
#	LOOP FUSION
	@echo "Total time,PSNR" > $(prefix)loop_fusion.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_Loop_Fusion); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)loop_fusion.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)loop_fusion.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)loop_fusion
	@echo "Run completed. Results saved in $(prefix)loop_fusion.csv"
#	################################################################################################
#	FUNCTION INLINING
	@echo "Total time,PSNR" > $(prefix)function_inlining.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_Function_Inlining); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)function_inlining.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)function_inlining.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)function_inlining
	@echo "Run completed. Results saved in $(prefix)function_inlining.csv"
#	################################################################################################
#	LOOP INVARIANT CODE MOTION
	@echo "Total time,PSNR" > $(prefix)loop_Invvariant_code_motion.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_Loop_Invariant_code_motion); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)loop_Invvariant_code_motion.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)loop_Invvariant_code_motion.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)loop_Invvariant_code_motion
	@echo "Run completed. Results saved in $(prefix)loop_Invvariant_code_motion.csv"
#	################################################################################################
#	COMMON SUBEXPRESSION ELIMINATION
	@echo "Total time,PSNR" > $(prefix)common_subexpression_elimination.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_Common_Subexpression_Elimination); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)common_subexpression_elimination.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)common_subexpression_elimination.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)common_subexpression_elimination
	@echo "Run completed. Results saved in $(prefix)common_subexpression_elimination.csv"
#	################################################################################################
#	STRENGTH REDUCTION
	@echo "Total time,PSNR" > $(prefix)Strength_Reduction.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_Strength_Reduction); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)Strength_Reduction.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)Strength_Reduction.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)Strength_Reduction
	@echo "Run completed. Results saved in $(prefix)Strength_Reduction.csv"

run_spec: $(EXECUTABLES)
	@echo "Total time,PSNR" > $(prefix)KAPA.csv # CSV header
	@total_time_sum=0; total_time_sq_sum=0; count=0; \
	for i in `seq 1 12`; do \
		output=$$(./sobel_KAPA); \
		time=$$(echo "$$output" | grep "Total time" | awk '{print $$4}'); \
		psnr=$$(echo "$$output" | grep "PSNR" | awk '{print $$9}'); \
		if [ -n "$$time" ]; then \
			echo "$$time,$$psnr" >> $(prefix)KAPA.csv; \
		else \
			echo "Error: could not extract time for execution $$i" >> $(prefix)KAPA.csv; \
		fi; \
	done; \
	python3 calculate_stats.py $(prefix)KAPA
	@echo "Run completed. Results saved in $(prefix)KAPA.csv"
# make stats prefix=test

stats:
	@if [ -z "$(prefix)" ]; then \
		echo "Error: Please provide a 'prefix' argument for the CSV files."; \
		exit 1; \
	fi
	python3 calculate_stats.py $(prefix)