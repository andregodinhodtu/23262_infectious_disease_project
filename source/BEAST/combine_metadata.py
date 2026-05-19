#!/usr/bin/env python3
import sys
import csv
import re

def extract_year(date_str):
    """Extracts the year from a date string (e.g., '10/10/2017' -> '2017')."""
    if not date_str:
        return ""
    return date_str.split('/')[-1].strip()

def extract_id(sample_name):
    """
    Extracts the numerical ID following '_id' if present (e.g., 'ST152_id46074_ABE4195' -> '46074').
    If '_id' is not found, returns the full sample name.
    """
    match = re.search(r'_id(\d+)', sample_name)
    if match:
        return match.group(1)
    return sample_name

def detect_delimiter(file_path):
    """Detects if the CSV file uses a comma or a semicolon as a separator."""
    with open(file_path, mode='r', encoding='utf-8-sig') as f:
        first_line = f.readline()
        return ';' if ';' in first_line else ','

def main():
    if len(sys.argv) != 6:
        print("Usage: python3 combine_metadata.py <tanz_samples.txt> <tanz_meta.csv> <aug_samples.txt> <aug_meta.csv> <output.csv>")
        sys.exit(1)
        
    tanz_samples_file = sys.argv[1]
    tanz_meta_file = sys.argv[2]
    aug_samples_file = sys.argv[3]
    aug_meta_file = sys.argv[4]
    output_file = sys.argv[5]
    
    # 1. Load Tanzania metadata into a dictionary
    tanz_meta = {}
    tanz_delim = detect_delimiter(tanz_meta_file)
    with open(tanz_meta_file, mode='r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f, delimiter=tanz_delim)
        for row in reader:
            row_clean = {k.strip(): v.strip() for k, v in row.items() if k is not None}
            key = row_clean.get('Sequence file name')
            if key:
                tanz_meta[key] = row_clean

    # 2. Load Augmented metadata into a dictionary
    aug_meta = {}
    aug_delim = detect_delimiter(aug_meta_file)
    with open(aug_meta_file, mode='r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f, delimiter=aug_delim)
        for row in reader:
            row_clean = {k.strip(): v.strip() for k, v in row.items() if k is not None}
            key = row_clean.get('id')
            if key:
                aug_meta[key] = row_clean

    output_rows = []

    # 3. Process Tanzania samples
    with open(tanz_samples_file, mode='r', encoding='utf-8') as f:
        for line in f:
            sample = line.strip()
            if not sample:
                continue
            lookup_key = extract_id(sample)
            meta = tanz_meta.get(lookup_key) or tanz_meta.get(sample)
            
            year = ""
            st = ""
            country = "Tanzania" # Default for this dataset
            if meta:
                year = extract_year(meta.get('Date of isolation', ''))
                st = meta.get('ST', '')
            
            output_rows.append({
                'sample_name': sample,
                'year': year,
                'country': country,
                'ST': st
            })

    # 4. Process Augmented samples
    with open(aug_samples_file, mode='r', encoding='utf-8') as f:
        for line in f:
            sample = line.strip()
            if not sample:
                continue
            lookup_key = extract_id(sample)
            meta = aug_meta.get(lookup_key) or aug_meta.get(sample)
            
            year = ""
            st = ""
            country = ""
            if meta:
                year = meta.get('year', '')
                st = meta.get('ST (MLST)', '')
                country = meta.get('country', '')
                
            output_rows.append({
                'sample_name': sample,
                'year': year,
                'country': country,
                'ST': st
            })

    # 5. Write the combined output mapping file
    with open(output_file, mode='w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['sample_name', 'year', 'country', 'ST'])
        writer.writeheader()
        for row in output_rows:
            writer.writerow(row)
            

if __name__ == '__main__':
    main()