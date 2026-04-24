#!/bin/bash
#PBS -W group_list=course_23262 -A course_23262
#PBS -N prokka_group1
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/prokka/prokka.err
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/prokka/prokka.log
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -l walltime=06:00:00

module purge
module load tools ngs pestat
module load hmmer/3.1b2 aragorn/1.2.36 barrnap/0.7 signalp/4.1c infernal/1.1.1
module load tbl2asn/20200706 jre/1.8.0-openjdk minced/0.2.0
module load perl/5.36.1
module load prokka/1.12

INPUT_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies_QC_passed"
OUTPUT_BASE="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/pan_genome_GWAS/prokka"

cd "$INPUT_DIR" || exit

# Looping over all the genomes
for assembly in *.fasta; do
	# Getting the name of the sample
	sample=${assembly%.fasta}

	# --prefix : pour que tous les fichiers de sortie commencent par le nom du sample
	prokka --kingdom Bacteria \
   		--genus Staphylococcus \
   		--species aureus \
		--outdir "$OUTPUT_BASE/$sample" \
   		--prefix "$sample" \
		--locustag "$sample" \
		--cpus 8 \
		"$assembly"
done
