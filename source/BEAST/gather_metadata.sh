#!/bin/bash
# This script is to be used as a command line, as it's just file manipulation
# Goal: merge metadata from the Tanzania samples and the augmented data, in a general csv from which all sample names match with the one actually used

PY_SCRIPT="/home/projects/course_23262/group/group1/23262_infectious_disease_project/source/BEAST/combine_metadata.py"

TANZ_SAMPLES="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/sample_list_QC_passed.txt"
TANZ_META="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/BEAST_metadata/Tanzania_metadata.csv"
AUG_SAMPLES="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/sample_list_augm_postQC.txt"
AUG_META="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/BEAST_metadata/augmented_metadata.csv"

OUTPUT_BEAST_META="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/BEAST_metadata/beast_metadata_combined.csv"

module purge
module load tools
module load anaconda3/2025.06-1

python3 "$PY_SCRIPT" "$TANZ_SAMPLES" "$TANZ_META" "$AUG_SAMPLES" "$AUG_META" "$OUTPUT_BEAST_META"

#Then create a file containing only samples and date, to import into BEAUTi

awk -F',' 'NR>1 {print $1"\t"$2}' "$OUTPUT_BEAST_META" > /home/projects/course_23262/group/group1/23262_infectious_disease_project/data/BEAST_metadata/beast_dates_only.txt
