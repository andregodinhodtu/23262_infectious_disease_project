#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N virulencefinder_array_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/virulencefinder/errs/
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/virulencefinder/logs/
#PBS -m n
#PBS -l nodes=1:ppn=4
#PBS -l mem=16gb
#PBS -l walltime=4:00:00
#PBS -t 1-62%20

RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/virulencefinder"
echo Working directory is $RESULTS_DIR
cd $RESULTS_DIR

module purge
module load tools
module load anaconda3/2023.09-0
module load kma/1.2.5
module load perl/5.36.1
module load ncbi-blast/2.2.31+

SAMPLE=$(sed -n "${PBS_ARRAYID}p" "$RESULTS_DIR/../sample_list.txt")

virulence_finder_path="/home/projects/course_23262/tools/virulencefinder/virulencefinder.py"
db_path="/home/projects/course_23262/tools/virulencefinder/virulencefinder_db/"
assembly_dir="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies"
raw_reads_dir="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/raw_data/Staphylococcus_aureus_Tanzania"
OUT_DIR="./${SAMPLE}"

mkdir -m777 -p $OUT_DIR

# Option 1 --- assembled genome
python $virulence_finder_path \
    -o $OUT_DIR \
    -d s.aureus_exoenzyme,s.aureus_hostimm,s.aureus_toxin \
    -p $db_path \
    -i ${assembly_dir}/${SAMPLE}.fasta

# Option 2 --- raw reads
# python $virulence_finder_path \
#     -o $OUT_DIR \
#     -d s.aureus_exoenzyme,s.aureus_hostimm,s.aureus_toxin \
#     -p $db_path \
#     -i ${raw_reads_dir}/${SAMPLE}_R1.trim.fq.gz \
#        ${raw_reads_dir}/${SAMPLE}_R2.trim.fq.gz
