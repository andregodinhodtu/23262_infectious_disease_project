#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N kmerfinder_array_group1
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/kmerfinder/errs
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/kmerfinder/logs
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
RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/kmerfinder"
echo Working directory is $RESULTS_DIR
cd $RESULTS_DIR

# Should we use assembled genome for kmer_finder or raw reads?

#Loading necessary modules
module unload
module load tools
module load anaconda3/2023.09-0
module load perl/5.36.1
module load kma/1.2.5

# Getting the sample corresponding to the current index
SAMPLE=$(sed -n "${PBS_ARRAYID}p" "$RESULTS_DIR/../sample_list.txt")

kmer_finder_path="/home/projects/course_23262/tools/kmerfinder/kmerfinder.py"
db_path="/home/projects/course_23262/tools/kmerfinder/kmerfinder_db/bacteria/bacteria.ATG"
tax_path="/home/projects/course_23262/tools/kmerfinder/kmerfinder_db/bacteria/bacteria.tax"
assembly_dir="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies"
OUT_DIR="./${SAMPLE}"

mkdir -m777 -p $OUT_DIR

python $kmer_finder_path \
    -o $OUT_DIR \
    -x \
    -db $db_path \
    -tax $tax_path \
module unload
module load tools
module load anaconda3/2023.09-0
module load perl/5.36.1
module load kma/1.2.5

SAMPLE=$(sed -n "${PBS_ARRAYID}p" "$RESULTS_DIR/../sample_list.txt")

kmer_finder_path="/home/projects/course_23262/tools/kmerfinder/kmerfinder.py"
db_path="/home/projects/course_23262/tools/kmerfinder/kmerfinder_db/bacteria/bacteria.ATG"
tax_path="/home/projects/course_23262/tools/kmerfinder/kmerfinder_db/bacteria/bacteria.tax"
assembly_dir="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies"
OUT_DIR="./${SAMPLE}"

mkdir -m777 -p $OUT_DIR

python $kmer_finder_path \
    -o $OUT_DIR \
    -x \
    -db $db_path \
    -tax $tax_path \
    -i ${assembly_dir}/${SAMPLE}.fasta
