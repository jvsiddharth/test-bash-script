#!/bin/bash
# Script: fetch_nav.sh
# Purpose: Extract full AMFI NAV data fields into TSV or JSON
# Fields: SchemeCode, ISIN_Payout_Growth, ISIN_Reinvestment, SchemeName, NAV, Date
# Options: Save as tsv, json, or both

URL="https://www.amfiindia.com/spages/NAVAll.txt"
TSV_OUT="schemes.tsv"
JSON_OUT="schemes.json"

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 [tsv|json|both]"
  exit 1
fi

# Fetch and parse data
DATA=$(curl -s "$URL" | awk -F';' 'NR>1 && NF>=6 {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}')

# Save as TSV
if [[ $1 == "tsv" || $1 == "both" ]]; then
  echo -e "SchemeCode\tISIN_Payout_Growth\tISIN_Reinvestment\tSchemeName\tNAV\tDate" > "$TSV_OUT"
  echo "$DATA" >> "$TSV_OUT"
  echo "✅ Saved TSV file: $TSV_OUT"
fi

# Save as JSON
if [[ $1 == "json" || $1 == "both" ]]; then
  echo "[" > "$JSON_OUT"
  echo "$DATA" | awk -F'\t' '{
    printf "  {\"SchemeCode\":\"%s\", \"ISIN_Payout_Growth\":\"%s\", \"ISIN_Reinvestment\":\"%s\", \"SchemeName\":\"%s\", \"NAV\":\"%s\", \"Date\":\"%s\"}", $1, $2, $3, $4, $5, $6
    if (NR != NR) { printf ",\n" } else { printf "\n" }
  }' | sed '$!s/$/,/' >> "$JSON_OUT"
  echo "]" >> "$JSON_OUT"
  echo "✅ Saved JSON file: $JSON_OUT"
fi

