#!/bin/sh
#SBATCH --job-name=star_mapping
#SBATCH --cpus-per-task=34
#SBATCH --mem=128gb
#SBATCH --time=1:55:00
#SBATCH --output=JobName.%j.log
#SBATCH --partition=IXG6154-AI-common

source ~/soft/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

READS1="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_trim/Eg_Treg_S71_R1_001_trimmed.fastq.gz"
READS2="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_trim/Eg_Treg_S71_R2_001_trimmed.fastq.gz"
OUTPUT_DIR="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_star"

mkdir -p "$OUTPUT_DIR"
ulimit -n 65536

STAR \
  --runThreadN 32 \
  --runMode alignReads \
  --genomeDir /home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq/STAR_index \
  --readFilesIn $READS1 $READS2 \
  --readFilesCommand zcat \
  --outFileNamePrefix ${OUTPUT_DIR}/RNA_ \
  --outSAMtype BAM SortedByCoordinate \
  --quantMode GeneCounts \
  --outTmpDir /home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/star_tmp

echo "Alignment Done"
