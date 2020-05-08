# ----
# this script is used to perform blastp searches
# it has three steps:
# 1. blast the reference proteome to itself
# 2. blast the reference proteome to query 1
# 3. blast the reference proteome to query 2
# ----
#
# Bin He
# 7 mai 2020
#

echo "blastp for Bacillus Anthracis Ames Ancestor against itself"
# gunzip decompress the gzipped fasta file and pipe it to blastp
# -query - will take the query from standard input
gunzip -c ../data/GCA_000008445.1_ASM844v1_protein.faa.gz | blastp -db ../data/blastdb/B_anthracis -query - -outfmt 7 -out ../output/ref-self-blast.txt 


echo "blastp for B. anthracis against Bacillus cereus G9241"
gunzip -c ../data/GCA_000008445.1_ASM844v1_protein.faa.gz | blastp -db ../data/blastdb/B_cereus_G9241 -query - -outfmt 7 -out ../output/ref-query1-blast.txt

echo "blastp for B. anthracis against Bacillus cereus 10987"
gunzip -c ../data/GCA_000008445.1_ASM844v1_protein.faa.gz | blastp -db ../data/blastdb/B_cereus_10987 -query - -outfmt 7 -out ../output/ref-query2-blast.txt
