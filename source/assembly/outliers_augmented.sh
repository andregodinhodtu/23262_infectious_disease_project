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

cd "$QC_folder" || exit

#We have to modify the names of some assemblies that were problematic for downstream analysis (prokka annotation)
mv "ST22_id37156_S. aureus SA82.fasta" "ST22_id37156_SA82.fasta"
mv "ST5477_id37103_st5477i_wp2017.fasta" "ST5477_id37103_wp2017.fasta"
mv "ST5477_id37107_st5477ii_wp2017.fasta" "ST5477_id37107_wp2017.fasta"
mv "ST7847_id38591_FF22_BC00410-2.fasta" "ST7847_id38591_FF22.fasta"
mv "ST8_id37152_S. aureus SA20.fasta" "ST8_id37152_SA20.fasta"
mv "ST97_id37151_S. aureus SA18.fasta" "ST97_id37151_SA18.fasta"
