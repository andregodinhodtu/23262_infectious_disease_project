#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N roary_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/roary.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/roary.log
#PBS -l nodes=1:ppn=16
#PBS -l mem=64gb
#PBS -l walltime=12:00:00

module purge
module load tools ngs pestat
module load parallel/20170822
module load mcl/14-137
module load cd-hit/4.6.1
module load fasttree/2.1.9
module load roary/3.13.0
module load anaconda3/2025.06-1

WORKING_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/"

PLOT_SCRIPT="/home/projects/course_23262/course/week08/pangenome/roary_output/roary_plot/roary_plots.py"

mkdir -p -m 777 "$GFF_folder"
mkdir -p -m 777 "$OUTPUT_DIR"


# Constructing a phylogeny tree from the aligned core genes
cd "$WORKING_DIR" || exit
FastTree -nt -gtr "${WORKING_DIR}core_gene_alignment.aln" > "${WORKING_DIR}core_genome_tree.nwk"

# generating plots
python "$PLOT_SCRIPT" "${WORKING_DIR}core_genome_tree.nwk" "${WORKING_DIR}gene_presence_absence.csv" --labels
