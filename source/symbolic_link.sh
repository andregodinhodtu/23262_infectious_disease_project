#!/bin/bash
# This script is to be used as a command line, as it's just file manipulation
# Goal: set a symbolic link in the raw_data folder to get easier access to raw data

cd /home/projects/course_23262/group/group1/23262_infectious_disease_project/data/trimmed_data
ln -s /home/projects/course_23262/project_exam_dataset/Staphylococcus_aureus_Tanzania .
