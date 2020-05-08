# ----
# this script is used to download the required bacterial genome from NCBI
# modified from Madeline's github repo/data/README.md
# I simply combined the wget commands there into this script
# ----
#
# Bin He
# 7 mai 2020
#

cd ../data/

echo "Downloading Bacillus Anthracis Ames Ancestor, Accession No.:AE017334"
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/008/445/GCA_000008445.1_ASM844v1/GCA_000008445.1_ASM844v1_protein.faa.gz


echo "Bacillus cereus G9241, Accession No.:AAEK00000000"
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/167/215/GCA_000167215.1_ASM16721v1/GCA_000167215.1_ASM16721v1_protein.faa.gz


echo "Bacillus cereus ATCC 10987, Accession No.:AE017194"
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/008/005/GCA_000008005.1_ASM800v1/GCA_000008005.1_ASM800v1_protein.faa.gz
