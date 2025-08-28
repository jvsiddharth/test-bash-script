# AMFI NAV Extractor

This is a simple Bash script to download **NAVAll.txt** from [AMFI India](https://www.amfiindia.com/spages/NAVAll.txt) and extract only **Scheme Name** and **NAV**.

## Usage

```bash
./fetch_nav.sh [tsv|csv|both]

```

## JSON or TSV

TSV is compact, easy for Excel/shell pipelines.
JSON is better if you’ll parse it in Python, Node, or an API.
You could easily convert TSV → JSON later if needed.
