#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N CSI_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/CSI_phylogeny/CSI.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/CSI_phylogeny/CSI.log
#PBS -l nodes=1:ppn=4
#PBS -l mem=32gb
#PBS -l walltime=16:00:00


REF_FILE="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/CSI_Phylogeny/S_Aureus_ref.fsa"
OUTPUT_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/CSI_phylogeny/run_csi"
DATA_CSI="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/CSI_phylogeny/data_csi"

mkdir -m 777 -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR" || exit

# Run CSI
/home/projects/course_23262/run_csi_phylogeny.sh -o "$OUTPUT_DIR" -r "$REF_FILE" -i "$DATA_CSI"/*.fasta
