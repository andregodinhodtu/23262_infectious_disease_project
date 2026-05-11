#!/bin/bash
# This script is to be used as a command line, as it's just file manipulation
# Goal: to create new folder and sample list without the discarded outliers


# Create destinations folder and file
QC_folder="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies_augm_postQC/"
mkdir -p -m 777 "$QC_folder"

LIST_FILE="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/sample_list_augm_postQC.txt"
# Overwriting the file in case it already existed
> "$LIST_FILE"

# Getting all the outliers name and creating a new list

outliers=" ST121_id42066_CA-MRSA-117 ST121_id42067_CA-MRSA-118 ST121_id42076_CA-MRSA-127 ST121_id42112_CA-MRSA-164 ST121_id42141_CA-MRSA-198 ST121_id42143_CA-MRSA-200 ST121_id42171_HA-MRSA-47 ST121_id42178_HA-MRSA-59 ST152_id42099_CA-MRSA-150 ST152_id42101_CA-MRSA-152 ST152_id42132_CA-MRSA-187 ST152_id42164_HA-MRSA-37 ST22_id42176_HA-MRSA-56 ST72_id42177_HA-MRSA-58 ST8_id42161_HA-MRSA-33 ST97_id42130_CA-MRSA-185 ST152_id46056_AAD9642 "


cd /home/projects/course_23262/group/group1/23262_infectious_disease_project/data/mlstpub_data/africa_genomes || exit # security if the cd fail
for assembly in *.fasta; do
	sample=${assembly%.fasta}
	# Ignoring the outliers by checking if the sample is in their list
	if [[ ! " $outliers " =~ " $sample " ]]; then
    		cp "$assembly" "$QC_folder/$assembly"
		echo "$sample" >> "$LIST_FILE"
	fi
done

