#!/bin/sh
#SBATCH --job-name=download_ref
#SBATCH --cpus-per-task=4
#SBATCH --mem=16gb
#SBATCH --time=2:00:00
#SBATCH --output=JobName.%j.log
#SBATCH --partition=IXG6154-AI-common

REF_DIR="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq"
mkdir -p "$REF_DIR"

wget -P "$REF_DIR" https://ftp.ensembl.org/pub/release-110/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
wget -P "$REF_DIR" https://ftp.ensembl.org/pub/release-110/gtf/homo_sapiens/Homo_sapiens.GRCh38.110.gtf.gz

gunzip "$REF_DIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"

echo "Download Done"
