#!/bin/sh
#SBATCH --job-name=JobName        # Job name
#SBATCH --cpus-per-task=1         # Run on a single CPU
#SBATCH --mem=5gb                 # Job memory request
#SBATCH --time=00:10:00           # Time limit hrs:min:sec
#SBATCH --output=JobName.%j.log   # Standard output and error log
#SBATCH --partition=IXG6154-AI-common

OUTDIR=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_assembly_results/quast_spades
SPADES=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_assembly_results/spades
SPADES_NEW=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_assembly_results/spades_new

PYTHONPATH=/home/STUDY/FBMF/bioinformatics/soft python3 /home/STUDY/FBMF/bioinformatics/soft/bin/quast.py \
    ${SPADES}/scaffolds.fasta \
    ${SPADES_NEW}/scaffolds.fasta \
    --labels "SPAdes,SPAdes_new" \
    --min-contig 0 \
    -o ${OUTDIR}
