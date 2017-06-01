############################################################

# Parse HNSCC RNA-seq data - Virtual Box

############################################################

# read in the meta data from the shared folder
read.delim("/media/sf_venv_files/metadata_clean.txt", header=T) -> bcodeFileID_v2

# set directory where data is
dir = "/home/vagrant/data"

# get list of files without parcel (logs)  
files = dir(dir)[-grep("parcel",dir(dir))]

fpkm_dir = files[grep("FPKM.txt",files)]

fpkm_uq_dir = files[grep("FPKM-UQ.txt",files)]

htseq_counts_dir = files[grep("htseq.counts",files)]

############################################################

# read in and parse FPKM

fpkm_data = vector("list", length(fpkm_dir))

for(i in 1:length(fpkm_dir)){
  print(i)
  read.delim(file=paste(dir, fpkm_dir[i], sep="/"), header=F) -> fpkm_data[[i]]
  
  row.names(fpkm_data[[i]]) <- fpkm_data[[i]][,1]
  
  fpkm_data[[i]][ , 2, drop = FALSE] -> fpkm_data[[i]]
  
  names(fpkm_data[[i]]) <- bcodeFileID_v2[bcodeFileID_v2[,"file_name"] %in% fpkm_dir[i],1]
}

head(fpkm_data[[1]])
head(fpkm_data[[2]])

do.call(cbind, fpkm_data) -> fpkm_data_full


############################################################

# read in and parse FPKM UQ

fpkm_uq_data = vector("list", length(fpkm_uq_dir))

for(i in 1:length(fpkm_uq_dir)){
  print(i)
  read.delim(file=paste(dir, fpkm_uq_dir[i], sep="/"), header=F) -> fpkm_uq_data[[i]]
  
  row.names(fpkm_uq_data[[i]]) <- fpkm_uq_data[[i]][,1]
  
  fpkm_uq_data[[i]][ , 2, drop = FALSE] -> fpkm_uq_data[[i]]
  
  names(fpkm_uq_data[[i]]) <- bcodeFileID_v2[bcodeFileID_v2[,"file_name"] %in% fpkm_uq_dir[i],1]
}

head(fpkm_uq_data[[1]])
head(fpkm_uq_data[[2]])

do.call(cbind, fpkm_uq_data) -> fpkm_uq_data_full

############################################################

# read in and parse htseq counts

hitseq_data = vector("list", length(htseq_counts_dir))

for(i in 1:length(htseq_counts_dir)){
  print(i)
  read.delim(file=paste(dir, htseq_counts_dir[i], sep="/"), header=F) -> hitseq_data[[i]]
  
  row.names(hitseq_data[[i]]) <- hitseq_data[[i]][,1]
  
  hitseq_data[[i]][ , 2, drop = FALSE] -> hitseq_data[[i]]
  
  names(hitseq_data[[i]]) <- bcodeFileID_v2[bcodeFileID_v2[,"file_name"] %in% htseq_counts_dir[i],1]
}

head(hitseq_data[[1]])
head(hitseq_data[[2]])

do.call(cbind, hitseq_data) -> hitseq_data_full

############################################################

# save data

save(fpkm_data_full, file="/media/sf_venv_files/fpkm_data_full.rda")

save(fpkm_uq_data_full, file="/media/sf_venv_files/fpkm_uq_data_full.rda")

save(hitseq_data_full, file="/media/sf_venv_files/hitseq_data_full.rda")

write.table("/media/sf_venv_files/fpkm_data_full.txt", x= fpkm_data_full, sep="\t", quote=F)

write.table("/media/sf_venv_files/fpkm_uq_data_full.txt", x= fpkm_uq_data_full, sep="\t", quote=F)

write.table("/media/sf_venv_files/hitseq_data_full.txt", x=hitseq_data_full, sep="\t", quote=F)
