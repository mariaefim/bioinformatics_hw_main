#!/bin/bash
#SBATCH --job-name=htseq_count
#SBATCH --cpus-per-task=2
#SBATCH --mem=8gb
#SBATCH --time=0:30:00
#SBATCH --output=JobName.%j.log
#SBATCH --partition=IXG6154-AI-common

source ~/soft/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

BAM="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/res_star/RNA_Aligned.sortedByCoord.out.bam"
GTF="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/data/ref_seq/Homo_sapiens.GRCh38.110.gtf"
OUT="/home/STUDY/FBMF/studfbmf02_05/hw/hw_6/res/htseq_counts.txt"

htseq-count --format bam \
            --order pos \
            --stranded no \
            --type exon \
            --idattr gene_id \
            $BAM $GTF > $OUT

