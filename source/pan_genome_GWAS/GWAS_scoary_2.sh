#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N GWAS_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/scoary_GWAS.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/scoary_GWAS.log
#PBS -l nodes=1:ppn=4
#PBS -l mem=32gb
#PBS -l walltime=6:00:00

module purge
module load tools ngs
module load anaconda3/2023.09-0
module load scoary/1.6.16


ROARY_DIR=/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/
OUTPUT_DIR=/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/scoary_GWAS/
TRAITS_FILE=/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/traits_GWAS.csv

mkdir -p -m 777 "$OUTPUT_DIR"

scoary -t "$TRAITS_FILE" -g "$ROARY_DIR/gene_presence_absence.csv" -o "$OUTPUT_DIR" -u -c I EPW --threads 4
