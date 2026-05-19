#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N beast_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/BEAST/CSIrun.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/BEAST/CSIrun.log
#PBS -l nodes=1:ppn=4
#PBS -l mem=32gb
#PBS -l walltime=16:00:00

module purge
module load tools
module load beast/1.10.4
module load beagle-lib/3.0.1

#first run with core genome alignment
# XML_FILE="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/BEAST_metadata/BEAST_fulldata.xml"
# OUTPUT_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/BEAST/full_run"

#second run with CSI SNPs alignment
XML_FILE="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/BEAST_metadata/BEAST_CSIrun.xml"
OUTPUT_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/BEAST/Beast_CSIrun"

# To allow BEAST to use RAM to manipulate our large XML file (only needed when we tried with the core genome alignment)
export _JAVA_OPTIONS="-Xmx16g"

mkdir -p -m 777 "$OUTPUT_DIR"

cd "$OUTPUT_DIR" || exit

# Run BEAST
beast -threads 4 -beagle -beagle_CPU -beagle_thread_count 4 "$XML_FILE"

