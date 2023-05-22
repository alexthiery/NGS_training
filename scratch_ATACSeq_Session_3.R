
# https://rpubs.com/tiagochst/atac_seq_workshop
# https://bernatgel.github.io/karyoploter_tutorial//Examples/EncodeEpigenetics/EncodeEpigenetics.html 

# Load required libraries
library(karyoploteR)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(ELMER)
library("org.Hs.eg.db")

# Plot parameters, only to look better
pp <- getDefaultPlotParams(plot.type = 1)
pp$leftmargin <- 0.15
pp$topmargin <- 15
pp$bottommargin <- 15
pp$ideogramheight <- 5
pp$data1inmargin <- 10
pp$data1outmargin <- 0

# Get transcripts annotation to get HNF4A regions
tssAnnot <- ELMER::getTSS(genome = "hg19")
tssAnnot <- tssAnnot[tssAnnot$external_gene_name == "HNF4A"]

# plot will be at  the HNF4A range +- 50Kb
HNF4A.region <- range(c(tssAnnot)) + 50000
HNF4A.region

# Start by plotting gene tracks
kp <- plotKaryotype(zoom = HNF4A.region, genome = "hg19", cex = 0.5, plot.params = pp)
genes.data <- makeGenesDataFromTxDb(
  TxDb.Hsapiens.UCSC.hg19.knownGene,
  karyoplot = kp,
  plot.transcripts = TRUE, 
  plot.transcripts.structure = TRUE
)
genes.data <- addGeneNames(genes.data = genes.data)

genes.data <- mergeTranscripts(genes.data = genes.data)

kp <- plotKaryotype(
  zoom = HNF4A.region,
  genome = "hg38",
  cex = 0.5,
  plot.params = pp
)
kpAddBaseNumbers(
  kp,
  tick.dist = 20000,
  minor.tick.dist = 5000,
  add.units = TRUE,
  cex = 0.4,
  tick.len = 3
)
kpPlotGenes(
  kp,
  data = genes.data,
  r0 = 0,
  r1 = 0.25,
  gene.name.cex = 0.5
)

# Start to plot bigwig files
big.wig.files <- dir(
  path = "./data/NF-ATACseq_alignment/bwa/merged_library/bigwig/",
  pattern = ".bigWig",
  all.files = T,
  full.names = T
)
big.wig.files

out.at <- autotrack(
  1:length(big.wig.files), 
  length(big.wig.files), 
  margin = 0.3, 
  r0 = 0.3,
  r1 = 1
)

kpAddLabels(
  kp, 
  labels = "ATAC-Seq", 
  r0 = out.at$r0, 
  r1 = out.at$r1, 
  side = "left",
  cex = 1,
  srt = 90, 
  pos = 3, 
  label.margin = 0.1
)

for(i in seq_len(length(big.wig.files))) {
  bigwig.file <- big.wig.files[i]
  
  # Define where the track will be ploted
  # autotrack will simple get the reserved space (from out.at$r0 up to out.at$r1)
  # and split in equal sizes for each bigwifile, i the index, will control which 
  # one is being plotted
  at <- autotrack(i, length(big.wig.files), r0 = out.at$r0, r1 = out.at$r1, margin = 0.2)
  
  # Plot bigwig
  kp <- kpPlotBigWig(
    kp, 
    data = bigwig.file, 
    ymax = "visible.region", 
    r0 = at$r0, 
    col = ifelse(grepl("ESCC",bigwig.file),"#0000FF","#FF0000"),
    r1 = at$r1
  )
  computed.ymax <- ceiling(kp$latest.plot$computed.values$ymax)
  
  # Add track axis
  kpAxis(
    kp, 
    ymin = 0, 
    ymax = computed.ymax, 
    numticks = 2,
    r0 = at$r0, 
    r1 = at$r1,
    cex = 0.5
  )
  
  # Add track label
  kpAddLabels(
    kp, 
    labels = ifelse(grepl("ESCC",bigwig.file),"ESCC","EAC"),
    r0 = at$r0, 
    r1 = at$r1, 
    cex = 0.5, 
    label.margin = 0.01
  )
}






