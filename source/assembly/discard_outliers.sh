#!/bin/bash
# This script is to be used as a command line, as it's just file manipulation
# Goal: to create new folder and sample list without the discarded outliers


# Create destinations folder and file
QC_folder="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies_QC_passed/"
mkdir -p -m 777 "$QC_folder"

LIST_FILE="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/sample_list_QC_passed.txt"
# Overwriting the file in case it already existed
> "$LIST_FILE"

# Getting all the outliers name and creating a new list

outliers=" R0047_DADST030 R0051_DADST045 R0052_BH0034 R0052_DADST001 R0052_DADST013-B R0052_DADST015 R0052_DADST053 R0052_DADST067 R0052_DADST091 "

cd /home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies || exit # security if the cd fail
for assembly in *.fasta; do
	sample=${assembly%.fasta}
	# Ignoring the outliers by checking if the sample is in their list
	if [[ ! " $outliers " =~ " $sample " ]]; then
    		cp "$assembly" "$QC_folder/$assembly"
		echo "$sample" >> "$LIST_FILE"
	fi
done

