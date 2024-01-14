library(tidyverse)
library(scater)
library(scran)
library(scuttle)
library(DropletUtils)
library(BiocParallel)

# function that reads in a 10x h5 file and returns a SummarizedExperiment
# that where counts are summed across all cells, such that one apparent sample
# is returned
pseudobulkify <- function(fl, nm=fl) {
  raw <- read10xCounts(fl)

  raw <- raw[,colSums(counts(raw)) > 0] # this seems to speed it up a lot

  return(summarizeAssayByGroup(raw,rep(nm,ncol(raw)),
                            statistics="sum",
                            BPPARAM = MulticoreParam(snakemake@threads)))
}

dir <- snakemake@input

h5 <- paste0(dir,"/outs/raw_feature_bc_matrix.h5")

se <- pseudobulkify(h5, nm=snakemake@wildcards$sample)

write_rds(se,snakemake@output$rds)