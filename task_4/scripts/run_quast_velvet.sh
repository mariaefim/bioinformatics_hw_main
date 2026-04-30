#!/bin/sh
#SBATCH --job-name=JobName        # Job name
#SBATCH --cpus-per-task=1         # Run on a single CPU
#SBATCH --mem=5gb                 # Job memory request
#SBATCH --time=00:10:00           # Time limit hrs:min:sec
#SBATCH --output=JobName.%j.log   # Standard output and error log
#SBATCH --partition=IXG6154-AI-common

OUTDIR=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_assembly_results/quast_velvet
VELVET=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_assembly_results/velvet
VELVET_NEW=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_assembly_results/velvet_new

PYTHONPATH=/home/STUDY/FBMF/bioinformatics/soft python3 /home/STUDY/FBMF/bioinformatics/soft/bin/quast.py \
    ${VELVET}/k51/contigs.fa \
    ${VELVET_NEW}/k51_new/contigs.fa \
    --labels "Velvet_k51,Velvet_k51_new" \
    --min-contig 0 \
    -o ${OUTDIR}
