#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N plasmidfinder_array_group1
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/plasmidfinder/errs/
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/plasmidfinder/logs/
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=4
### Memory
#PBS -l mem=16gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 3 hours)
#PBS -l walltime=4:00:00
#Using Job Arrays to launch multiple jobs simultaneously
#PBS -t 1-62%20

# Go to the directory from where the job was submitted (initial directory is $HOME)
RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/plasmidfinder"
echo Working directory is $RESULTS_DIR
cd $RESULTS_DIR

# Load all required modules for the job
module purge
module load tools
module load anaconda3/2023.09-0
module load kma/1.2.5
module load perl/5.36.1
module load ncbi-blast/2.2.31+

# Getting the sample corresponding to the current index
SAMPLE=$(sed -n "${PBS_ARRAYID}p" "$RESULTS_DIR/../sample_list.txt")

plasmid_finder_path="/home/projects/course_23262/tools/plasmidfinder/plasmidfinder.py"
db_path="/home/projects/course_23262/tools/plasmidfinder/plasmidfinder_db"
raw_reads_dir="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/raw_data/Staphylococcus_aureus_Tanzania"
assembly_dir="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies"
OUT_DIR="./${SAMPLE}"

mkdir -m777 -p $OUT_DIR

python $plasmid_finder_path \
    -o $OUT_DIR \
    -d Inc18,Rep1,Rep2,Rep3,RepA_N,RepL,Rep_trans,NT_Rep \
    -p $db_path \
    -i ${assembly_dir}/${SAMPLE}.fasta

# Option 2 --- raw reads
# python $plasmid_finder_path \
#     -o $OUT_DIR \
#     -d Inc18,Rep1,Rep2,Rep3,RepA_N,RepL,Rep_trans,NT_Rep \
#     -p $db_path \
#     -i ${raw_reads_dir}/${SAMPLE}_R1.trim.fq.gz \
#        ${raw_reads_dir}/${SAMPLE}_R2.trim.fq.gz
