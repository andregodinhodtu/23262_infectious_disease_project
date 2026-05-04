#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N roary_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/roary.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/roary.log
#PBS -l nodes=1:ppn=4
#PBS -l mem=16gb
#PBS -l walltime=06:00:00

module load tools ngs pestat
module load mafft/7.245
module load parallel/20170822
module load prank/140603
module load mcl/14-137
module load cd-hit/4.6.1
module load fasttree/2.1.9
module load roary/3.13.0

WORKING_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/prokka"
GFF_folder="${WORKING_DIR}/all_GFFs"
OUTPUT_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/roary/"

PLOT_SCRIPT="/home/projects/course_23262/course/week08/pangenome/roary_output/roary_plot/roary_plots.py"

mkdir -p -m 777 "$GFF_folder"
mkdir -p -m 777 "$OUTPUT_DIR"

cd "$WORKING_DIR" || exit

# Gathering all GFF files in one folder
for folder in */; do
    # Ignoring the destination folder containing all gff file
	sample=${folder%/}
    if [[ "$sample" != "all_GFFs" ]]; then
        cp "${sample}/${sample}.gff" "${GFF_folder}/${sample}.gff"
    fi
done

# Running roary on this folder

roary -f "$OUTPUT_DIR" -p 4 -e -n -v "$GFF_folder"/*gff

# Constructing a phylogeny tree from the aligned core genes
cd "$OUTPUT_DIR" || exit
FastTree -nt -gtr "${OUTPUT_DIR}core_gene_alignment.aln" > "${OUTPUT_DIR}core_genome_tree.nwk"

# generating plots
python "$PLOT_SCRIPT" "${OUTPUT_DIR}core_genome_tree.nwk" "${OUTPUT_DIR}gene_presence_absence.csv"
