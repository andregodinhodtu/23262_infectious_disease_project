#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=course_23262 -A course_23262
### Job name
#PBS -N resfinder_array_group1
### Output files
#PBS -e /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/resfinder/errs/
#PBS -o /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/resfinder/logs/
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=4
### Memory
#PBS -l mem=16gb
### Requesting time
#PBS -l walltime=4:00:00
### Job array — one job per QC-passed assembly
#PBS -t 1-53%20
 
# PATHS 
RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/resfinder"
ASSEMBLY_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies_QC_passed"
SAMPLE_LIST="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/sample_list_QC_passed.txt"
 
db_path_res="/home/projects/course_23262/database/resfinder_db_v2.2.1"
db_path_point="/home/projects/course_23262/database/pointfinder_db_v4.0.1"

 
echo "Working directory is $RESULTS_DIR"
cd $RESULTS_DIR
 
# Load modules
module purge
module load tools
module load anaconda3/2023.09-0
module load perl/5.36.1   
module load ncbi-blast/2.2.31+
module load resfinder/4.5.0
 
# Get sample for this array index
SAMPLE=$(sed -n "${PBS_ARRAYID}p" "$SAMPLE_LIST")
echo "Processing sample: $SAMPLE"
 
ASSEMBLY="${ASSEMBLY_DIR}/${SAMPLE}.fasta"
 
if [ ! -f "$ASSEMBLY" ]; then
    echo "ERROR: Assembly not found: $ASSEMBLY"
    exit 1
fi

OUT_DIR="${RESULTS_DIR}/${SAMPLE}"
mkdir -m777 -p "$OUT_DIR"
 
echo "Running ResFinder on $SAMPLE..."
 
python -m resfinder \
    -o "$OUT_DIR" \
    -s "Staphylococcus aureus" \
    --db_path_res "$db_path_res" \
    --db_path_point "$db_path_point" \
    -ifa "$ASSEMBLY" \
    --point \
    --acquired \
    -l 0.6 \
    -t 0.9
 
echo "ResFinder complete for $SAMPLE"
