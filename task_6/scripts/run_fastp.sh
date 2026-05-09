#!/bin/sh
#SBATCH --job-name=run_fastp
#SBATCH --cpus-per-task=4
#SBATCH --mem=5gb
#SBATCH --time=00:10:00
#SBATCH --output=JobName.%j.log
#SBATCH --partition=IXG6154-AI-common

source ~/soft/miniconda3/etc/profile.d/conda.sh
conda activate base

TRIMMED=/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_trim

mkdir -p "$TRIMMED"

fastp \
    --in1 /home/STUDY/FBMF/bioinformatics/rnaseq_map_star/raw_data/Eg_Treg_S71_R1_001.fastq.gz \
    --in2 /home/STUDY/FBMF/bioinformatics/rnaseq_map_star/raw_data/Eg_Treg_S71_R2_001.fastq.gz \
    --out1 "$TRIMMED/Eg_Treg_S71_R1_001_trimmed.fastq.gz" \
    --out2 "$TRIMMED/Eg_Treg_S71_R2_001_trimmed.fastq.gz" \
    --json "$TRIMMED/Eg_Treg_S71_fastp.json" \
    --html "$TRIMMED/Eg_Treg_S71_fastp.html" \
    --cut_right \
    --cut_window_size 5 \
    --cut_mean_quality 20 \
    --length_required 36 \
    --thread 4
