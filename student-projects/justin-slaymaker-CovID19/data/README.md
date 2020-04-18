# Data source table
| File name | Content | Source | Date |
|-----------|---------|--------|------|
| coronavirus-lu-2020.fasta | 8 genome sequences of Wuhan SARS-Cov2 | <https://bigd.big.ac.cn/ncov/release_genome> | 2020-04-17 |
| MG772934.1.gb | GenBank format file for Bat SARS-like coronavirus | <https://www.ncbi.nlm.nih.gov/nuccore/MG772934.1> | 2020-04-17 |

# Notes
1. the coronavirus data were downloaded by searching for the accession # NMDC60013002 on <https://bigd.big.ac.cn/ncov/release_genome>, select all sequences except the two with low qualitites, and use the "Download Selected Sequences" function to download the fasta sequences. The resulting fasta file contains 8 records, with the following length:
```bash
$ bioawk -c fastx '{print length($seq)}' coronavirus-lu-2020.fasta
29891
29890
29891
29896
29891
29866
29868
29872
```
1. the Bat SARS-like coronavirus isolate bat-SL-CoVZXC21 complete genome, under the accession # MG772934 was referenced in the original paper. It's sequence was downloaded from NCBI nucleotide database.
