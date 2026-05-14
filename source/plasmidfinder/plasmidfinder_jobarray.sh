#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name
#PBS -N plasmidfinder_array_group1
### Output files
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/plasmidfinder/errs/
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/plasmidfinder/logs/
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=4
### Memory
#PBS -l mem=16gb
### Requesting time
#PBS -l walltime=4:00:00
### Using Job Arrays to launch multiple jobs simultaneously
#PBS -t 1-62%20

RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/plasmidfinder"
echo "Working directory is $RESULTS_DIR"
cd "$RESULTS_DIR"

module purge
module load tools
module load anaconda3/2023.09-0
module load kma/1.2.5
module load perl/5.36.1
module load ncbi-blast/2.2.31+

# --- paths ---
plasmid_finder_path="/home/projects/course_23262/tools/plasmidfinder/plasmidfinder.py"
db_path="/home/projects/course_23262/tools/plasmidfinder/plasmidfinder_db"
assembly_dir_our="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies_QC_passed"
assembly_dir_aug="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies_augm_postQC"

DB_LIST="Inc18,Rep1,Rep2,Rep3,RepA_N,RepL,Rep_trans,NT_Rep"

# --- sample names for this array index ---
SAMPLE_OUR=$(sed -n "${PBS_ARRAYID}p" "$RESULTS_DIR/../sample_list_QC_passed.txt")
SAMPLE_AUG=$(sed -n "${PBS_ARRAYID}p" "$RESULTS_DIR/../sample_list_augm_postQC.txt")

# --- original data ---
if [ -n "$SAMPLE_OUR" ]; then
    OUT_OUR="$RESULTS_DIR/our_data/${SAMPLE_OUR}"
    echo "[our_data] sample: $SAMPLE_OUR -> $OUT_OUR"
    mkdir -m775 -p "$OUT_OUR"
    python "$plasmid_finder_path" \
        -o "$OUT_OUR" \
        -d "$DB_LIST" \
        -p "$db_path" \
        -i "${assembly_dir_our}/${SAMPLE_OUR}.fasta"
else
    echo "[our_data] no sample at array index ${PBS_ARRAYID}, skipping"
fi

# --- augmented data ---
if [ -n "$SAMPLE_AUG" ]; then
    OUT_AUG="$RESULTS_DIR/augmented/${SAMPLE_AUG}"
    echo "[augmented] sample: $SAMPLE_AUG -> $OUT_AUG"
    mkdir -m775 -p "$OUT_AUG"
    python "$plasmid_finder_path" \
        -o "$OUT_AUG" \
        -d "$DB_LIST" \
        -p "$db_path" \
        -i "${assembly_dir_aug}/${SAMPLE_AUG}.fasta"
else
    echo "[augmented] no sample at array index ${PBS_ARRAYID}, skipping"
fi

echo "Array task ${PBS_ARRAYID} done."
# Option 2 --- raw reads
# python $plasmid_finder_path \
#     -o $OUT_DIR \
#     -d Inc18,Rep1,Rep2,Rep3,RepA_N,RepL,Rep_trans,NT_Rep \
#     -p $db_path \
#     -i ${raw_reads_dir}/${SAMPLE}_R1.trim.fq.gz \
#        ${raw_reads_dir}/${SAMPLE}_R2.trim.fq.gz
