#!/bin/bash
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name
#PBS -N kmerfinder_summary_group1
### Output files
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/kmerfinder/errs
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/kmerfinder/logs
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=1:thinnode
### Memory
#PBS -l mem=8gb
### Requesting time
#PBS -l walltime=1:00:00

RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/kmerfinder/"
echo Working directory is $RESULTS_DIR
cd $RESULTS_DIR

module purge
module load tools
module load anaconda3/2023.09-0
module load perl/5.36.1
module load kma/1.2.5

summary_script="/home/projects/course_23262/tools/WGStools_summary/kmerfinder_summary.py"
output_file="kmerfinder_summary"

python $summary_script \
    -i $RESULTS_DIR/. \
    -o $output_file
