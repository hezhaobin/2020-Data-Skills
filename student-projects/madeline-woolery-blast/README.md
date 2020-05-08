# Project information
_References_

David A. Rasko, Michael R. Altherr, Cliff S. Han, Jacques Ravel, Genomics of the Bacillus cereus group of organisms, FEMS Microbiology Reviews, Volume 29, Issue 2, April 2005, Pages 303–329, https://doi.org/10.1016/j.fmrre.2004.12.005.

David A. Rasko, Garry S.A. Myers, Jacques Ravel, Visualization of comparative genomic analyses by BLAST score ratio. BMC Bioinformatics 6, 2 (2005). https://doi.org/10.1186/1471-2105-6-2.

# Goal of my effort
Madeline was unable to reproduce the Figure 2 of the first paper even though the scripts were provided and well documented. The main issue is incompatibility in the software package. My goal is to help Madeline get the BLAST Score Ratio (BSR) to work.

# What is the purpose of BSR
Honestly it isn't completely clear to me why the method is applied specifically to three genomes, one as reference and the other two as query. One possibility is that in those days only a few model organisms have their genomes well-assembled, and one way to analyze the relationship of non-model strains/species genomes may be to first compare them to the same reference genome.

# How are BLAST Ratio Score calculated
1. The program requires three proteomes (in FASTA)
    - one is designated as the reference and the other two as queries.
1. Each peptide in the reference proteome is compared to itself -- for each peptide, the highest BLAST score, i.e. to itself, is recorded as the reference score for that peptide.
1. Each peptide in the reference proteome is further compared to the two query proteoms. For each reference peptide, the highest BLAST score in each query proteome is recorded Query1 and Query2.
1. BLAST score ratio is then calculated "by dividing the Query score by the Reference score for each Reference peptide".
    $BSR pair = ( BSR1 = Query1/Reference, BSR2 = Query2/Reference )$
1. In one of the output graphs, the BSR for each reference peptide against the two query proteomes were used as x, y coordinates, and points are plotted in a scatter plot, with additional colors to denote the four quadrants. 

## relevant code in the author's PERL script

```perl
############################
### GET THE BEST_HIT VALUES#
############################

($score, $orf) = blast_log($reference);
($scoreQ1, $orfQ1) = blast_log($query);
($scoreQ2, $orfQ2) = blast_log($query2);

###################################
## CALCULATE THE BLAST SCORE RATIO#
###################################

## if both gene have no blast hit (NBH), then ratio should be 0 and not 1

if ($orfQ1 eq "NBH") {
	$r1 = 0.0001;
}else {
	$r1 = $scoreQ1/$score;
}
if ($orfQ2 eq "NBH") {
	$r2 = 0.0001;
}else {
	$r2 = $scoreQ2/$score;
}

push(@stats1, $r1);
push(@stats2, $r2);

my $value = $hashR{$orf};
@temp2 = split("\t", $value);
chomp $temp2[2];
```

## Test blast+
1. Downloaded BSR_all_files (see `script` folder), and installed blast+ on my MBA
    ```bash
    $ brew tap brewsci/science; brew tap brewsci/bio
    $ brew install blast
    ```
1. Make blast database
    ```bash
    # assume you are in the directory with the .pep files
    $ makeblastdb -in <FILE>.pep -dbtype prot -parse_ids -title TITLE -out <LibName>
    ```
1. Perform blast
    ```bash
    $ blastp -db <LibName> -query <QUERY>.pep -outfmt 7 # output format 7 is tabular with comments. output format 6 is tabular without comments
               						# see https://www.biostars.org/p/88944/ for more details
    ```


## Reproduce the analysis
1. Download all data
    `$ sh script/download_protein_sequences.sh`
1. Make blast database
    `$ sh script/make-blast-db.sh`
1. Perform blastp
    `$ sh script/run-blastp.sh`
