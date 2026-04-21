#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N quast
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/spades/errs
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/spades/logs
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=4
### Memory
#PBS -l mem=16gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 3 hours)
#PBS -l walltime=4:00:00

module purge
module load tools
module load anaconda2/4.4.0
module load perl
module load quast/5.0.2

# Create destination folder
Quast_folder="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/spades/quast"
mkdir -p -m 777 "$Quast_folder"

ASSEMBLY_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies"

quast.py --threads 4 -o "$OUT_DIR" "$ASSEMBLY_DIR"/*.fasta

