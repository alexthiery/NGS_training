## Using the inbuilt-test data
# https://haibol2016.github.io/ATACseqQCWorkshop/articles/ATACseqQC_workshop.html

## prepare the example BAM files for importing
bamFile <- system.file("extdata", "GL1.bam",
                       package = "ATACseqQC", mustWork = TRUE)
bamFileLabels <- gsub(".bam", "", basename(bamFile))

## bamQC
bamQC(bamFile, outPath = NULL) # only reads mapped to chr1

bamQC(OMNI_bam_path, outPath = NULL) # no reads here!!! not even to chrM

## frag size
fragSize <- fragSizeDist(bamFile, bamFileLabels) # makes plot

fragSize <- fragSizeDist(OMNI_bamFile) # doesn't work


