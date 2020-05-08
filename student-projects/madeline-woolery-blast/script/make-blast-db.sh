# ----
# this script is used to make blast database from the downloaded protein sequences
# ----
#
# Bin He
# 7 mai 2020
#

cd ../data/
mkdir blastdb # create a folder to contain the blast databases
cd blastdb

echo "Formatting Bacillus Anthracis Ames Ancestor, Accession No.:AE017334"
gunzip -c ../GCA_000008445.1_ASM844v1_protein.faa.gz | makeblastdb -in - -parse_seqids -dbtype prot -title B_anthracis_ames -out B_anthracis


echo "Formatting Bacillus cereus G9241, Accession No.:AAEK00000000"
gunzip -c ../GCA_000167215.1_ASM16721v1_protein.faa.gz | makeblastdb -in - -parse_seqids -dbtype prot -title B_cereus_G9241 -out B_cereus_G9241


echo "Formatting Bacillus cereus ATCC 10987, Accession No.:AE017194"
gunzip -c ../GCA_000008005.1_ASM800v1_protein.faa.gz | makeblastdb -in - -parse_seqids -dbtype prot -title B_cereus_10987 -out B_cereus_10987
