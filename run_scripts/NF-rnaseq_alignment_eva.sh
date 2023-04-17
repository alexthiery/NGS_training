#!/bin/sh
#SBATCH --job-name=nf-core_rnaseq_alignment
#SBATCH -t 72:00:00
#SBATCH --mail-type=ALL,ARRAY_TASKS
#SBATCH --mail-user=alex.thiery@crick.ac.uk

## LOAD REQUIRED MODULES
ml purge
ml Java/11.0.2
ml Nextflow/22.10.3
ml Singularity/3.6.4
ml Graphviz

export NXF_VER=22.10.3
export NXF_SINGULARITY_CACHEDIR=/nemo/lab/briscoej/working/hamrude/NF_singularity
export NXF_HOME=/flask/scratch/briscoej/hamrude/NGS_training

## UPDATE PIPLINE
nextflow pull nf-core/rnaseq

## RUN alignment
nextflow run nf-core/rnaseq \
    -r 3.10.1 \
    -c ./conf/test_full_RNA_eva.config \
    --outdir ./output/NF-RNAseq_alignment \
    --email eva.hamrud@crick.ac.uk \
    -resume