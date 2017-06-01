############################################################

# Parse HNSCC RNA-seq data

############################################################

# setwd("/Users/choonoo/HNSCC_parse_RNAseq")
# save.image("parse_rnaseq_v2.rda")
# load("parse_rnaseq_v2.rda")

library(readr)
library(tidyjson)

############################################################

## Read in libraries
library(readr)
library(tidyjson)

## Read in manifest file
mani <- readr::read_delim("/Users/choonoo/HNSCC_parse_RNAseq/venv_files/gdc_manifest_20170525_163733.txt", delim = "\t")

## ID represents downloaded folders
newManifest <- mani[c("id", "filename")]

## Read in metadata file
metadataFile <- jsonlite::fromJSON("/Users/choonoo/HNSCC_parse_RNAseq/venv_files/metadata.cart.2017-05-25T16_38_26.225791.json")

metadatas <- tidyjson::read_json("/Users/choonoo/HNSCC_parse_RNAseq/venv_files/metadata.cart.2017-05-25T16_38_26.225791.json")

## Parse the attributes of the .json file 
cases <- names(grep("^TCGA", unlist(attributes(metadatas)$JSON[[1]][[1]]), value = TRUE))[[9]]
type <- grep("file_id", names(unlist(attributes(metadatas)$JSON[[1]][[1]])), value = TRUE)[[2]]
idx <- match(c(cases, type), names(unlist(attributes(metadatas)$JSON[[1]][[1]])))

## Loop through file and extract the IDs matched with the file name
metaList <- attributes(metadatas)[["JSON"]][[1L]]
IDS <- lapply(seq_along(metaList), function(i) {
  bcodeIdx <- match("cases.samples.portions.analytes.aliquots.submitter_id",
                    names(unlist(metaList[i])))
  fileIdx <- match("file_name", names(unlist(metaList[i])))
  unlist(metaList[i])[c(bcodeIdx, fileIdx)]
})

bcodeFileID <- data.frame(do.call(rbind, IDS), stringsAsFactors = FALSE)

# Includes primary tumor sample, metastatic, and solid normal tissue expression
unique(sapply(strsplit(bcodeFileID[,1], "-"),"[",4))

# 501 unique patients
length(unique(paste(sapply(strsplit(bcodeFileID[,1], "-"),"[",2),sapply(strsplit(bcodeFileID[,1], "-"),"[",3),sep="-")))

bcodeFileID_v2 = bcodeFileID

bcodeFileID_v2[,2] <- gsub(".gz","",bcodeFileID_v2[,2])

# Save metadata in shared folder
write.table(file="/Users/choonoo/HNSCC_parse_RNAseq/venv_files/metadata_clean.txt",x=bcodeFileID_v2, sep="\t",quote=F,row.names=F)


