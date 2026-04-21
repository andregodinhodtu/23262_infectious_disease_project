#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N spades_array
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
#Using Job Arrays to launch multiple jobs simultaneously
#PBS -t 1-62%20

# Go to the directory from where the job was submitted (initial directory is $HOME)
RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/spades"
echo Working directory is $RESULTS_DIR
cd $RESULTS_DIR

#Loading necessary modules

module unload
module load tools
module load anaconda3/2023.09-0
module load spades/3.15.5

# Getting the sample corresponding to the current index
SAMPLE=$(sed -n "${PBS_ARRAYID}p" "$RESULTS_DIR/../sample_list.txt")

#Defining input and output
DATA_DIR="/home/projects/course_23262/project_exam_dataset/Staphylococcus_aureus_Tanzania"
OUT_DIR="./${SAMPLE}"

#Creating folder for this sample
mkdir -m777 -p $OUT_DIR 

#De novo assembly using SPAdes
spades.py -k 21,33,55,77,99,127 --careful --cov-cutoff 2.0 \
          -t 4 -m 16 \
          -o $OUT_DIR \
          -1 ${DATA_DIR}/${SAMPLE}_R1.trim.fq.gz \
          -2 ${DATA_DIR}/${SAMPLE}_R2.trim.fq.gz
