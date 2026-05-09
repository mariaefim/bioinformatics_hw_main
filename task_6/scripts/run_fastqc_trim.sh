#!/bin/sh
#SBATCH --job-name=run_fastqc     # Job name
#SBATCH --cpus-per-task=4         # Run on a single CPU
#SBATCH --mem=5gb                 # Job memory request
#SBATCH --time=00:10:00           # Time limit hrs:min:sec
#SBATCH --output=JobName.%j.log   # Standard output and error log
#SBATCH --partition=IXG6154-AI-common

source ~/soft/miniconda3/etc/profile.d/conda.sh
conda activate base

TRIMMED=/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_trim
RESULTS=/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_new
mkdir -p "$RESULTS"
fastqc "$TRIMMED"/*_trimmed.fastq.gz \
    --outdir "$RESULTS" \
    --threads 4

multiqc "$RESULTS" \
    --outdir /home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_new \
    --filename multiqc_report_trimmed
