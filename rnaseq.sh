## install gdc client on virtual box
wget https://gdc.nci.nih.gov/files/public/file/gdc-client_v1.0.1_Ubuntu14.04_x64.zip

unzip gdc-client_v1.0.1_Ubuntu14.04_x64.zip

## verify that program works
./gdc-client

## Create a local folder to be shared on Virutal Box and put the manifest file in there.

## Enable guest additions in Virtual Box

## Add yourself as a user in the group and restart the Virtual Box
sudo adduser yourusername vboxsf

## Add shared folder in the machine settings (auto mount)
## The folder will be saved in /media/sf_sharedfolder, where “sharedfolder” is the name of the shared folder

## In this case the shared folder is:

/Users/choonoo/HNSCC_parse_RNAseq/venv_files

## Use GDC Client to download the manifest

## Specify folder where to download files from the manifest:

mkdir files

## Download files

./gdc-client download --no-annotations -m /media/sf_venv_files/gdc_manifest_20170525_163733.txt -d ~/files/

## Note: If you get a notification that asks to overwrite annotations, just hit enter many times. The annotations file isn’t used in this workflow. Be careful not quit out because your download will stop.

## Put the nested files in a new folder:

mkdir data

find /home/vagrant/files/ -mindepth 2 -type f -exec mv -i '{}' /home/vagrant/data ';'

## Gunzip all files

cd /home/vagrant/data
gunzip *.gz

## Check the length of the folder, should be around 1638

## Run the local Rscript to map the File IDs to the Patient IDs (parse_rnaseq_local.r)

## Run the virtual pipeline
Rcript /media/sf_venv_files/parse_rnaseq_virtual.r

## Data should be about 546 columns and over 60,000 rows for each of the 3 RNA seq files