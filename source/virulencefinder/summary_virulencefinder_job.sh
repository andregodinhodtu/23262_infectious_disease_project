#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N virulencefinder_summary_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/virulencefinder/errs/
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/virulencefinder/logs/
#PBS -m n
#PBS -l nodes=1:ppn=1:thinnode
#PBS -l mem=8gb
#PBS -l walltime=1:00:00

RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/virulencefinder"
echo Working directory is $RESULTS_DIR
cd $RESULTS_DIR

module purge
module load tools
module load anaconda3/2023.09-0
module load kma/1.2.5
module load perl/5.36.1
module load ncbi-blast/2.2.31+

summary_script="/home/projects/course_23262/tools/WGStools_summary/virulencefinder_summary.py"
output_file="virulencefinder_summary"

python $summary_script \
    -i $RESULTS_DIR/. \
    -o $output_file
