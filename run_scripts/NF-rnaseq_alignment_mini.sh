#!/bin/sh
#SBATCH --job-name=nf-core_rnaseq_alignment
#SBATCH -t 72:00:00
#SBATCH --mail-type=ALL,ARRAY_TASKS
#SBATCH --mail-user=alex.thiery@crick.ac.uk

## LOAD REQUIRED MODULES
ml purge
ml Nextflow/21.10.6
ml Singularity/3.6.4
ml Graphviz

export TERM=xterm
export NXF_VER=21.10.6
export NXF_SINGULARITY_CACHEDIR=/camp/home/thierya/working/NF_singularity

## UPDATE PIPLINE
nextflow pull nf-core/rnaseq

## RUN alignment
nextflow run nf-core/rnaseq \
    -r 3.8 \
    -c ./conf/test_mini_RNA.config \
    --outdir ./output/NF-RNAseq_alignment_mini \
    --email alex.thiery@crick.ac.uk \
    -resume