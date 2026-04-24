#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N roary_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/roary.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/roary.log
#PBS -l nodes=1:ppn=4
#PBS -l mem=16gb
#PBS -l walltime=06:00:00

module load tools ngs pestat
module load mafft/7.245
module load parallel/20170822
module load prank/140603
module load mcl/14-137
module load cd-hit/4.6.1
module load fasttree/2.1.9
module load roary/3.13.0 

WORKING_DIR="home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/prokka"
GFF_folder="${WORKING_DIR}/all_GFFs/"
OUTPUT_BASE="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/prokka"

mkdir -p 777 "$GFF_fodler"

cd "$INPUT_DIR" || exit
for folder in */; do
    # Ignoring the logs and errs folders
    if [[ "$folder" != "all_GFFs/"]]; then
        sample=${folder%/}
        cp "${folder}scaffolds.fasta" "$Assembly_folder${sample}.fasta"
    fi
done

