#!/bin/bash

# Download files from GSE138002
cd data
wget -c "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE138002&format=file&file=GSE138002%5FFinal%5Fmatrix%2Emtx%2Egz" --output-document  GSE138002_Final_matrix.mtx.gz  &
wget -c "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE138002&format=file&file=GSE138002%5FFinal%5Fbarcodes%2Ecsv%2Egz" --output-document GSE138002_Final_barcodes.csv.gz &
wget -c "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE138002&format=file&file=GSE138002%5Fgenes%2Ecsv%2Egz" --output-document GSE138002_genes.csv.gz &
wait
echo "All files were downloaded"
