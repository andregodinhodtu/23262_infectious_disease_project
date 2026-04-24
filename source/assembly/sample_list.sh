#!/bin/bash
# This script is to be used as a command line, as it's just file manipulation to get a .txt list with all unique sample name

cd /home/projects/course_23262/group/group1/23262_infectious_disease_project/data/trimmed_data/Staphylococcus_aureus_Tanzania
ls *_R1.trim.fq.gz | sed 's/_R1.trim.fq.gz//' > /home/projects/course_23262/group/group1/23262_infectious_disease_project/results/sample_list.txt

