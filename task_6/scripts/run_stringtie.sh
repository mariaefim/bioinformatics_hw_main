#!/bin/bash
#SBATCH --job-name=stringtie_assemble
#SBATCH --cpus-per-task=4
#SBATCH --mem=32gb
#SBATCH --time=1:00:00
#SBATCH --output=JobName.%j.log
#SBATCH --partition=IXG6154-AI-common

source ~/soft/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

BAM="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_star/RNA_Aligned.sortedByCoord.out.bam"
GTF="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq/Homo_sapiens.GRCh38.110.gtf"
OUTDIR="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_stringtie"
mkdir -p "$OUTDIR"

stringtie "$BAM" \
  -G "$GTF" \
  -o "$OUTDIR/transcripts.gtf" \
  -p "$SLURM_CPUS_PER_TASK" \
  -e

