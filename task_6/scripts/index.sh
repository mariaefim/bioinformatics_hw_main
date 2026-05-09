#!/bin/sh
#SBATCH --job-name=index
#SBATCH --cpus-per-task=4
#SBATCH --mem=64gb
#SBATCH --time=2:00:00
#SBATCH --output=JobName.%j.log
#SBATCH --partition=IXG6154-AI-common

source ~/soft/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

STAR \
  --runThreadN 16 \
  --runMode genomeGenerate \
  --genomeDir /home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq/STAR_index \
  --genomeFastaFiles /home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
  --sjdbGTFfile /home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq/Homo_sapiens.GRCh38.110.gtf \
  --sjdbOverhang 75 \
  --outTmpDir /home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq/star_tmp

mkdir -p /home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq/star_index
