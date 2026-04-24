#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N mlst_group1
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/mlst/mlst.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/mlst/mlst.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=1
### Memory
#PBS -l mem=8gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 3 hours)
#PBS -l walltime=1:00:00

# Load all required modules for the job
module purge
module load tools
module load anaconda3/2023.09-0
module load kma/1.2.5
module load perl/5.36.1
module load ncbi-blast/2.17.0+
module load any2fasta/0.4.2
module load mlst/2.23.0


mlst_folder="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/mlst"
ASSEMBLY_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies_QC_passed"

mlst "$ASSEMBLY_DIR"/*.fasta > "$mlst_folder/mlst_summary.txt"
