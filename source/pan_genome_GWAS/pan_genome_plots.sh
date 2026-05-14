#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N plots_roary_g1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/plots_roary.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/plots_roary.log
#PBS -l nodes=1:ppn=16
#PBS -l mem=64gb
#PBS -l walltime=12:00:00

# IMPORTANT: check before submitting this job that roary has not created a subfolder within the roary folder
# This happens if the roary folder already exists when provided as an output directory for the roary anlaysis

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

cd "$WORKING_DIR" || exit # To create the python plots in the roary folder
# Constructing a phylogeny tree from the aligned core genes
FastTree -nt -gtr "${WORKING_DIR}core_gene_alignment.aln" > "${WORKING_DIR}core_genome_tree.nwk"

# generating plots
python "$PLOT_SCRIPT" "${WORKING_DIR}core_genome_tree.nwk" "${WORKING_DIR}gene_presence_absence.csv" --labels
