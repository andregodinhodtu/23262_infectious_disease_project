#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N roary_Tanz_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary_Tanz.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary_Tanz.log
#PBS -l nodes=1:ppn=16
#PBS -l mem=64gb
#PBS -l walltime=12:00:00

module purge
module load tools ngs pestat
module load parallel/20170822
module load mcl/14-137
module load cd-hit/4.6.1
module load fasttree/2.1.9
module load roary/3.13.0
module load anaconda3/2025.06-1

WORKING_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/prokka"
GFF_folder="${WORKING_DIR}/Tanzania_GFFs"
OUTPUT_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/Tanzania_roary/"
TANZANIA_SAMPLES="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/sample_list_QC_passed.txt"

mkdir -p -m 777 "$GFF_folder"

cd "$WORKING_DIR" || exit

while read -r sample; do
    # Quick verification if line from sample file is not empty
    if [[ -n "$sample" ]]; then
        SOURCE_GFF="${WORKING_DIR}/${sample}/${sample}.gff"
	# Quick verification if the .gff actually exists
        if [[ -f "$SOURCE_GFF" ]]; then
            cp "$SOURCE_GFF" "${GFF_folder}/${sample}.gff"
        else
            echo "Warning: GFF for $sample not found at $SOURCE_GFF"
        fi
    fi
done < "$TANZANIA_SAMPLES"
# Running roary on this folder

roary -f "$OUTPUT_DIR" -p 16 -e -n -v "${GFF_folder}/"*.gff

