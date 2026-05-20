#!/bin/bash
# =============================================================================
# download_pubmlst_africa_genomes.sh
#
# Downloads S. aureus genome assemblies from PubMLST for African isolates
# filtered by target ST types.
#
# Workflow:
#   1. Filter isolates_africa.tsv by target STs
#   2. Fetch all isolate IDs that have genome assemblies from PubMLST
#   3. Intersect: keep only African target-ST isolates that have assemblies
#   4. Download FASTA files for each matched isolate
#
# Usage:
#   ./download_pubmlst_africa_genomes.sh [input_tsv] [output_dir]
#
# Defaults:
#   input_tsv   = isolates_africa.tsv
#   output_dir  = africa_genomes
#
# Dependencies: bash, curl, awk, python3
# =============================================================================

set -euo pipefail

# --- Config ------------------------------------------------------------------

INPUT_TSV="${1:-isolates_africa.tsv}"
OUTDIR="${2:-africa_genomes}"

BASE_URL="https://rest.pubmlst.org/db/pubmlst_saureus_isolates"

TARGET_STS="8 22 72 97 121 152 243 5477 7840 7841 7845 7846 7847 7848"

# Intermediate files 
TMP_ST_FILTERED="africa_target_sts.tsv"
TMP_GENOME_IDS="all_genome_ids.txt"
FINAL_LIST="africa_target_sts_with_genomes.tsv"

KEEP_TMP="${KEEP_TMP:-0}"   # set KEEP_TMP=1 to retain intermediate files

# --- Checks ------------------------------------------------------------------

if [ ! -f "$INPUT_TSV" ]; then
    echo "ERROR: Input file '$INPUT_TSV' not found."
    echo "Usage: $0 [input_tsv] [output_dir]"
    exit 1
fi

echo "============================================="
echo " PubMLST S. aureus Africa Genome Downloader"
echo "============================================="
echo "Input file : $INPUT_TSV"
echo "Output dir : $OUTDIR"
echo "Target STs : $TARGET_STS"
echo ""

# --- Step 1: Filter by target STs --------------------------------------------

echo "[1/4] Filtering '$INPUT_TSV' for target STs..."

awk -v sts="$TARGET_STS" '
BEGIN {
    split(sts, a, " ")
    for (i in a) wanted[a[i]] = 1
}
NR==1 { print; next }
{ if ($NF in wanted) print }
' "$INPUT_TSV" > "$TMP_ST_FILTERED"

ST_COUNT=$(tail -n +2 "$TMP_ST_FILTERED" | wc -l)
echo "    Found $ST_COUNT isolates matching target STs"

if [ "$ST_COUNT" -eq 0 ]; then
    echo "ERROR: No isolates found for target STs. Check column format."
    exit 1
fi

# --- Step 2: Fetch all genome-having isolate IDs from PubMLST ---------------

echo ""
echo "[2/4] Fetching all isolate IDs with genome assemblies from PubMLST..."
echo "    (This may take ~30 seconds)"

curl -s "${BASE_URL}/genomes?return_all=1" | python3 -c "
import json, sys, re
d = json.load(sys.stdin)
ids = [re.search(r'/(\d+)$', u).group(1) for u in d['isolates']]
print('\n'.join(ids))
" > "$TMP_GENOME_IDS"

GENOME_COUNT=$(wc -l < "$TMP_GENOME_IDS")
echo "    Found $GENOME_COUNT isolates with genome assemblies in PubMLST"

# --- Step 3: Intersect -------------------------------------------------------

echo ""
echo "[3/4] Intersecting target ST isolates with genome-having isolates..."

awk '
NR==FNR         { genome_ids[$1]=1; next }
FNR==1          { print; next }
$1 in genome_ids { print }
' "$TMP_GENOME_IDS" "$TMP_ST_FILTERED" > "$FINAL_LIST"

FINAL_COUNT=$(tail -n +2 "$FINAL_LIST" | wc -l)
echo "    $FINAL_COUNT isolates have both target ST and a genome assembly"

if [ "$FINAL_COUNT" -eq 0 ]; then
    echo "ERROR: No isolates passed the genome filter. Nothing to download."
    exit 1
fi

echo ""
echo "    Breakdown by ST:"
tail -n +2 "$FINAL_LIST" | awk '{print $NF}' | sort -n | uniq -c | \
    awk '{printf "      ST%-8s %s isolates\n", $2, $1}'

# --- Step 4: Download genomes ------------------------------------------------

echo ""
echo "[4/4] Downloading genome assemblies to '$OUTDIR/'..."
mkdir -p "$OUTDIR"

OK=0
SKIP=0

tail -n +2 "$FINAL_LIST" | while IFS=$'\t' read -r ID ISOLATE REST; do
    ST=$(echo "$REST" | awk '{print $NF}')
    # Sanitise isolate name for use in filename (replace / and spaces)
    SAFE_ISOLATE=$(echo "$ISOLATE" | tr '/ ' '__')
    OUTFILE="${OUTDIR}/ST${ST}_id${ID}_${SAFE_ISOLATE}.fasta"

    HTTP=$(curl -s -o "$OUTFILE" -w "%{http_code}" \
        "${BASE_URL}/isolates/${ID}/contigs_fasta?header=original_designation")

    if [ "$HTTP" -eq 200 ] && [ -s "$OUTFILE" ]; then
        CONTIGS=$(grep -c "^>" "$OUTFILE")
        echo "  OK   ST=$ST  id=$ID  isolate=$ISOLATE  contigs=$CONTIGS"
        OK=$((OK + 1))
    else
        echo "  SKIP ST=$ST  id=$ID  isolate=$ISOLATE  (HTTP $HTTP)"
        rm -f "$OUTFILE"
        SKIP=$((SKIP + 1))
    fi
done

# --- Summary -----------------------------------------------------------------

echo ""
echo "============================================="
echo " Done"
echo "  Downloaded : $OK FASTA files -> $OUTDIR/"
echo "  Skipped    : $SKIP (no assembly or error)"
echo "  File list  : $FINAL_LIST"
echo "============================================="

# --- Cleanup -----------------------------------------------------------------

if [ "$KEEP_TMP" -eq 0 ]; then
    rm -f "$TMP_ST_FILTERED" "$TMP_GENOME_IDS"
fi
