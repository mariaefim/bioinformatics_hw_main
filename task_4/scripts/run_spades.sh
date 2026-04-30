#!/bin/sh
#SBATCH --job-name=JobName        # Job name
#SBATCH --cpus-per-task=1         # Run on a single CPU
#SBATCH --mem=5gb                 # Job memory request
#SBATCH --time=00:10:00           # Time limit hrs:min:sec
#SBATCH --output=JobName.%j.log   # Standard output and error log
#SBATCH --partition=IXG6154-AI-common

python3 /home/STUDY/FBMF/bioinformatics/soft/SPAdes-4.2.0-Linux/bin/spades.py \
    --careful \
    -1 /home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_de_novo/7_S4_L001_R1_001.fastq \
    -2 /home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_de_novo/7_S4_L001_R2_001.fastq \
    -o /home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_assembly_results/spades
