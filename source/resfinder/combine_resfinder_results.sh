#!/bin/bash
### Combine ResFinder array job results into TSV files for R analysis
### Usage: bash combine_resfinder_results.sh

RESULTS_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results/resfinder"
FILES_DIR="/home/projects/course_23262/group/group1/23262_infectious_disease_project/results_for_analysis/resfinder/our_data"
RESFINDER_OUT="${FILES_DIR}/all_resfinder_tab.tsv"
PHENO_OUT="${FILES_DIR}/all_pheno_table.tsv"
POINT_OUT="${FILES_DIR}/all_pointfinder.tsv"

echo "=== Combining ResFinder results ==="
echo "Results dir: $RESULTS_DIR"
echo ""

# --- ResFinder_results_tab.txt ---
echo "Processing ResFinder_results_tab.txt..."
header_written=false
count=0

for sample_dir in "$RESULTS_DIR"/*/; do
    SAMPLE=$(basename "$sample_dir")
    FILE="${sample_dir}/ResFinder_results_tab.txt"
    if [ ! -f "$FILE" ]; then continue; fi

    if [ "$header_written" = false ]; then
        echo -e "sample\t$(head -1 "$FILE")" > "$RESFINDER_OUT"
        header_written=true
    fi
    tail -n +2 "$FILE" | awk -v s="$SAMPLE" 'NF {print s"\t"$0}' >> "$RESFINDER_OUT"
    count=$((count + 1))
done
echo "  -> $count samples written to $(basename "$RESFINDER_OUT")"

# --- pheno_table_staphylococcus_aureus.txt ---
echo "Processing pheno_table_staphylococcus_aureus.txt..."
header_written=false
count=0

for sample_dir in "$RESULTS_DIR"/*/; do
    SAMPLE=$(basename "$sample_dir")
    FILE="${sample_dir}/pheno_table_staphylococcus_aureus.txt"
    if [ ! -f "$FILE" ]; then continue; fi

    if [ "$header_written" = false ]; then
        echo -e "sample\t$(head -1 "$FILE")" > "$PHENO_OUT"
        header_written=true
    fi
    tail -n +2 "$FILE" | awk -v s="$SAMPLE" 'NF {print s"\t"$0}' >> "$PHENO_OUT"
    count=$((count + 1))
done
echo "  -> $count samples written to $(basename "$PHENO_OUT")"

# --- PointFinder_results.txt ---
echo "Processing PointFinder_results.txt..."
header_written=false
count=0

for sample_dir in "$RESULTS_DIR"/*/; do
    SAMPLE=$(basename "$sample_dir")
    FILE="${sample_dir}/PointFinder_results.txt"
    if [ ! -f "$FILE" ]; then continue; fi

    if [ "$header_written" = false ]; then
        echo -e "sample\t$(head -1 "$FILE")" > "$POINT_OUT"
        header_written=true
    fi
    tail -n +2 "$FILE" | awk -v s="$SAMPLE" 'NF {print s"\t"$0}' >> "$POINT_OUT"
    count=$((count + 1))
done
echo "  -> $count samples written to $(basename "$POINT_OUT")"

# --- Summary ---
echo ""
echo "=== Done ==="
echo "Output files:"
for f in "$RESFINDER_OUT" "$PHENO_OUT" "$POINT_OUT"; do
    if [ -f "$f" ]; then
        lines=$(wc -l < "$f")
        echo "  $f  ($lines lines)"
    else
        echo "  $f  (NOT CREATED — no input files found)"
    fi
done
