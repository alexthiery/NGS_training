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

## UPDATE PIPLINE
nextflow pull nf-core/atacseq

## RUN alignment
nextflow run nf-core/atacseq \
    -r 2.0 \
    -c ./conf/test_full_ATAC.config \
    --outdir ./output/NF-ATACseq_alignment \
    --email alex.thiery@crick.ac.uk \
    -resume