#!/bin/sh
#SBATCH --job-name=JobName        # Job name
#SBATCH --cpus-per-task=1         # Run on a single CPU
#SBATCH --mem=5gb                 # Job memory request
#SBATCH --time=00:10:00           # Time limit hrs:min:sec
#SBATCH --output=JobName.%j.log   # Standard output and error log
#SBATCH --partition=IXG6154-AI-common
VELVET=/home/STUDY/FBMF/studfbmf02_05/soft/velvet
R1=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_de_novo/7_S4_L001_R1_001.fastq
R2=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_de_novo/7_S4_L001_R2_001.fastq
OUTDIR=/home/STUDY/FBMF/studfbmf02_05/hw/hw_4/genome_assembly_results/velvet
INS_LENGTH=300

for K in 31 41 51; do
    mkdir -p ${OUTDIR}/k${K}
    ${VELVET}/velveth ${OUTDIR}/k${K} ${K} -fastq -shortPaired ${R1} ${R2}
    ${VELVET}/velvetg ${OUTDIR}/k${K} -ins_length ${INS_LENGTH}
done
