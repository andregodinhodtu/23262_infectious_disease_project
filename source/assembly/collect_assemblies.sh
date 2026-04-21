#!/bin/bash
# This script is to be used as a command line, as it's just file manipulation
# Goal: move(copy) all assemblies(scaffolds.fasta files) from the result folder to the data one while renaming them
# This is to ensure better access and understanding

# Create destination folder
Assembly_folder="/home/projects/course_23262/group/group1/23262_infectious_disease_project/data/assemblies/"
mkdir -p -m 777 "$Assembly_folder"

# Getting the folder name for every assembly and copying it
cd /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/spades || exit # security if the cd fail
for folder in */; do
    # Ignoring the logs and errs folders
    if [[ "$folder" != "logs/" && "$folder" != "errs/" ]]; then
        sample=${folder%/}
    	cp "${folder}scaffolds.fasta" "$Assembly_folder${sample}.fasta"
    fi
done

