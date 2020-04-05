---
title: Alignment data workshop
author: Madeline Woolery
date: 2020-04-02
---
 
Working With Alignment Data
=================
 
## Before we start
 
- This workshop is intended to be completed on the ARGON computing cluster at the University of Iowa.
    a. if you are working off campus, first download and connect to VPN, following the instructions [here](https://its.uiowa.edu/vpn).
    b. if your personal computer is Windows-based and not set up for terminal access, log on to the fastx environment in your browser window.
    c. to connect to ARGON, open a terminal under FastX (or on your Mac / PuTTY), use `$ ssh <HawkID>@argon.hpc.uiowa.edu`. Replace "<HawkID>" with your actual HawkID. You will need to have 2-step verification set up.

- Make sure you have the book files cloned from Github (or at least Chapter 11) in your Argon home directory.
    - This should exist as a folder named `bds-files`, possibly under your home directory on ARGON `$ cd ~; ls`
    - If you don't have it on ARGON, after log in, issue the following command
        `$ git clone https://github.com/vsbuffalo/bds-files.git`
    - The files for Chapter 11 is under `bds-files/chapter-11-alignment/`
 
## Setup
 
### Check For Modules
 
1. Check if the modules needed for this workshop are downloaded. If you are using Argon, they should all be included.
1. bwa
    This stands for the Burrows-Wheeler Aligner and is a software package for mapping low-divergent sequences against a reference genome.
    ```bash
    $ module avail bwa # This command checks if the module is downloaded and should tell you the version downloaded if it is.
    $ module load bwa # Even if the modules are already downloaded, you will still have to load them to have them work. 
    ```
2. samtools
    This is a tool that will be used for several commands in this chapter.
    ```bash
    $ module avail samtools
    $ module load samtools
    ```
## Learning about SAM and BAM formats
1. The SAM header
1. The SAM alignment section
    - query name
    - bitwise flag
    - reference name
    - position
    - mapping quality
    - CIGAR string
    - reference next (of a paired-end read's partner)
    - position next (of a paired-end read's partner)
    - template length (for paired-end reads)
    - original read sequence (based on FASTQ file, but may be reverse complemented. why?)
    - read quality score (from FASTQ file)
## Command-Line Tools for Working with Alignments in the SAM Format
### Converting Between SAM and BAM Formats
 
```bash
$ cd ____ # navigate to the Chapter 11 directory in the book files
          # if you followed the instruction at the beginning
	  # this would be ~/bds-files/chapter-11-alignment
	  # remember to tab, don't type
```

As mentioned in the book, many samtools subcommands will require inputs that are in BAM format (recall that this is the binary format whereas SAM is plain-text). Take a peak at one of the SAM files to see what it looks like:

```bash
$ head celegans.sam
```

Using the command below, you can convert the celegans.sam file in this folder to a BAM format:

```bash
$ samtools view -b celegans.sam > celegans_copy.bam
$ ls # Check that the celegans_copy.bam file is now in your directory
```

Try converting a file from BAM to SAM using the below command (Note: if you exclude -h in this command, it will be converted without the header which can cause some issues with your analysis).

```bash
$ samtools view -h celegans.bam > celegans_copy.sam
$ samtools view -b celegans_copy.sam > celegans_copy.bam
```

As stated in the book, it is better to store and analyze files in BAM format but SAM format is helpful when you need to manually inspect files. 
 
### Sorting and Indexing Alignments
In order to sort alignments by their alignment positions:

```bash
$ samtools sort celegans_unsorted.bam -o celegans_sorted.bam # this command should only be used on files in BAM format
$ samtools index celegans_sorted.bam # this command creates an index of the file
$ ls # if the index command worked, you should have a file in your directory called "celegans_sorted.bam.bai"
```

### Extracting and Filtering Alignment
Once alignments have been sorted and indexed, you can filter out alignments you don't want to include in your analysis and extract the alignments of interest. What this means is that if you only want to analyze data on a specific chromosome or only a region of the chromosome, the command below allows you to "extract" just that part of the alignment from an otherwise huge BAM file.

```bash
$ samtools index NA12891_CEU_sample.bam # This is data from the 1000 Genomes Project
$ samtools view NA12891_CEU_sample.bam 1:215906469-215906652 | head -n 3 # This command views some of the alignments in the region specified on chromosome 1
$ samtools view -b NA12891_CEU_sample.bam 1:215906469-215906652 > USH2A_sample_alns.bam # This writes the alignments we viewed above in BAM format, note the "-b" flag. without it, the output will be in SAM format, even if you use .bam in the file name!
```

#### Optional
If you have a lot of regions, e.g. 1:xxx-yyy, 2:xxx-yyy, etc., all stored in a file of [BED format](https://genome.ucsc.edu/FAQ/FAQformat.html#format1), the following command may be used:

```bash
$ samtools view -L USH2A_exons.bed NA12891_CEU_sample.bam | head -n 3
$ less -S USH2A_exons.bed # take a look at what's inside a BED file
```

Although more columns can be present to provide additional information. More on that later.

### Filtering Alignments
The samtools view subcommand also has options to filter alignments that can be piped into another command or written in a file. If you are ever confused about the options for this subcommand, you can type in the following command to see a list of the flags that can be used:
```bash
$ samtools view
```

There are two options for samtools view for what outputs will contain. Using the flag "-f" will only output the reads with the specified flag(s) while using the flag "-F" will only output the reads without the specified flag(s).

```bash
$ samtools flags unmap
```

- What does the output tell you? 
- How many reads are unmapped?

```bash
$ samtools view -f 4 NA12891_CEU_sample.bam | head -n 3
```

This output includes reads that match the flag set mentioned above (the second column has the decimal representation corresponding to the unmapped set). This can be checked with:

```bash
$ samtools flags 69
$ samtools flags 181
```

- What else does this tell you about the reads in this set? 
- What are the differences between the 69 and 181 files?
 
Sometimes, you will want to find outputs with multiple bitwise flags set. For example, you may want to find the first reads that aligned for a proper pair alignment.

```bash
$ samtools flags READ1,PROPER_PAIR
```

This command tells you what the decimal representation is for these two bitwise flags which will again be shown in the second column. Then, using the decimal representation, you can use the samtools view command to extract these alignments:

```bash
$ samtools view -f 66 NA12891_CEU_sample.bam | head -n 3
```

If we wanted to exclude alignments from our output, we would use the -F flag mentioned earlier. First, we would need to identify the decimal representation for the categories we want to filter out and then we would apply this knowledge with the samtools view command.

```bash
$ samtools flags UNMAP
$ samtools view -F 4 NA12891_CEU_sample.bam | head -n 3 
```

Combining bits can be complicated but useful. It is possible to use both "-f" and "-F" flags in one command which can help to better filter your output. If you want your output to be reads that are aligned and paired but not in a proper pair, you would need to combine bits so that unmapped reads and proper pairs are excluded while paired ends are included. First, you need to determine what the decimal representations are for each bit.

```bash
$ samtools flags paired
$ samtools flags unmap,proper_pair
``` 

What were the decimal representations you will need?
```bash
$ samtools view -F 6 -f 1 NA12891_CEU_sample.bam | head -n 3
```
This command is excluding (-F) reads with the decimal representation "6" which corresponds to unmapped reads and proper pairs and is including reads (-f) with the decimal representation "1" which corresponds to paired reads.
 
It is a good idea to verify that the reads make sense. In order to do this, you can check the counts. For the example used above, the total number of reads that are mapped and paired should be equal to the sum of the reads that are mapped, paired, and properly paired and the number of reads that are mapped, paired, and not properly paired. 
```bash
$ samtools view -F 6 NA12891_CEU_sample.bam | wc -l 
```
This command is excluding the reads that are unmapped and properly paired.
```bash
$ samtools view -F 7 NA12891_CEU_sample.bam | wc -l
```
This shows the total number of reads that are  mapped, paired, and properly paired.
```bash
$ samtools view -F 6 -f 1 NA12891_CEU_sample.bam | wc -l 
```
This is the total number of reads that are  mapped, paired, and not properly paired. As mentioned above, we want the first number to be equal to the sum of the second two numbers to indicate that the results make sense. You can either add this up or use:
```bash
$ echo "201101 + 32527" | bc # bc stands for bench calculator
```
 
## Visualizing Alignments with samtools tview and the Integrated Genomics Viewer
### Overview of samtools tview
The samtools tview tool is useful for quickly looking at alignments in the terminal. This tool can only be used on position-sorted and indexed BAM files. Previously, we indexed the BAM file "NA12891_CEU_sample.bam" which was already position-sorted. Make sure you are in the Chapter 11 folder for the book files and that you can find this file (ls). Another helpful feature of the tview subcommand is that it can load the reference genome alongside the alignments. 
 
#### Download the Reference Genome (human_g1k_v37.fasta)
```bash
$ wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz
$ ls #  make sure you have the file "human_g1k_v37.fasta.gz"
$ gunzip human_g1k_v37.fasta.gz # unzip the file
$ shasum human_g1k_v37.fasta # You should check to make sure the SHA-1 value matches: d83eb9744f59bc6e9edd0ae4006bd39d693bc0a2
```

#### Using samtools tview

```bash
$ samtools tview NA12891_CEU_sample.bam human_g1k_v37.fasta
```

This command allows you to view the alignment we were working with earlier alongside its reference genome. This view is showing you the very beginning of a chromosome. In order to specify a position, you can use the option "-p":

```bash
$ samtools tview -p 1:215906469-215906652 NA12891_CEU_sample.bam \ human_g1k_v37.fasta
```

This opens the tview application which allows you to navigate around the chromosome and jump to particular regions. It also has options for changing the output format: the '\' tells the program to use display sequences as is rather than using "." for matchi

```bash
? # This command brings you to the help screen for the application. You can press "?" again to exit the help screen. tview is a good tool for quick previews of alignments, but the book recommends IGV (the Integrated Genomics Viewer) to look more closely at BAM data.
q # exit the tview window to access the IGV
```

### The Integrated Genomics Viewer
There are two ways you can access the IGV for this workshop:
1. Download IGV in Argon
    ```bash
    $ wget https://data.broadinstitute.org/igv/projects/downloads/2.8/IGV_Linux_2.8.2.zip
    $ unzip IGV_Linuz_2.8.2.zip
    $ cd IGV_Linuz_2.8.2.zip
    $ chmod a+x igv.sh # this makes the script executable
    $ ./igv.sh # this will execute the script and open the IGV in a new window
    ```
2. Open the IGV Application in the fastx Environment
    - Applications -> Bioinformatics -> IGV
    - If you choose to use the version on your desktop, you will need to either transfer the sorted and indexed files we prepared above to your local directory or complete the previous exercises on files in your local directory.
 
    The first thing you need to do once IGV opens is load the reference genome. This can be done by navigating to Genomes -> Load Genome from Server -> and select "Human (1kg, b37+decoy)" genome. 
 
Next, we need to load the BAM alignments we want to look at: File -> Load from file -> NA12891_CEU_sample.bam
 
You should notice that no alignments are currently shown. The next step is to focus the IGV on a region that contains our alignments of interest. In the textbox at the top of the window, enter the region "1:215,906,528-215,906,567".
 
You should now see alignments on your screen. The top pane shows where on the chromosome the viewer is focused on and the base pair positions. The middle pane shows the coverage and alignment tracks. The bottom pane shows the sequence and gene track information. You will notice that some of the letters are colored in the bottom pane. This means that the bases are mismatched between the read sequence and the reference. What are some reasons that the bases would be mismatched?
 
We are going to take a closer look to see if we can determine the cause of the variation. Hover your cursor over the alignments in the region around positions 215,906,547 and 215,906,548. You should see that this particular region has lower mapping quality than if you hovered over other regions. Can you tell if this is a case of true polymorphism or misalignment by inspecting the different reads?
 
Looking in the bottom pane, you may notice that the sequence shown is composed of low-complexity sequences consisting of Gs and Cs. GGC sequences can generate sequence-specific errors in Illumina data. Return to the terminal window and make sure you are in the Chapter 11 Directory. Using the samtools view, we can inspect the metadata to determine if this is an Illumina sequence:

```bash
$ samtools view -H NA12891_CEU_sample.bam | grep PL | tail -n 1
```

PL stands for sequencing platform. Was Illumina sequencing used for the reads in this alignment?
 
### The Pileup Format
This format is a plain-text format that stacks or "piles up" aligned reads at each chromosome position to summarize the reads' bases. This format is useful to identify variants. In this section of the workshop, you will be applying the samtools mpileup command to inspect the chromosome region you inspected in the previous section.

#### Using samtools mpileup

```bash
$ samtools mpileup --no-BAQ --region 1:215906528-215906567 \ 
--fasta-ref human_g1k_v37.fasta NA12891_CEU_sample.bam
```

- As shown above, mpileup is another tool that requires the inputs to be in BAM format. However, the reference genome can be used in FASTA format using "--fasta-ref". "--region" limits the pileup to the region that was specified in the command. "--no-BAQ" disables the Base Alignment Quality which is an additional feature of mpileup.
- The outputs of this command are pileups and stacked mismatches. However, it is possible to output variant calls instead using mpileup.

#### Variant Calling
```bash
$ samtools mpileup -v --no-BAQ --region 1:215906528-215906567 \ 
--fasta-ref human_g1k_v37.fasta NA12891_CEU_sample.bam \ 
> NA12891_CEU_sample.vcf.gz
```

- In this command, we have added the "-v" flag which indicates that VCF (or Variant Call Format) should be used. This command generates genotype likelihoods for every site in the specified region. This command then ends by telling mpileup to direct the output to a VCF file. There is a binary analog of VCF (called BCF) which could be specified in the command-line by replacing the "-v" flag with "--g". The resulting file is an intermediate file which can be used for further analysis steps.
- The "-u" flag can be used to force the output file to be uncompressed but this is not necessary to move on to the next step.
 
To view the intermediate file:
```bash
$ zgrep "^##" -v NA12891_CEU_sample.vcf.gz | \
awk 'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5$6,a[1],$9,$10}' 
```

bcftools call can then be used to process the information in the intermediate file to identify variant sites. You will need to check that it is downloaded.

```bash
$ module avail bcftools
$ module load bcftools
$ bcftools call -v -m NA12891_CEU_sample.vcf.gz > NA12891_CEU_sample_calls.vcf.gz
```

- "-m" stands for multiallelic caller
- "-v" means that only variant sites will be included in the output

```bash
$ zgrep "^##" -v NA12891_CEU_sample_calls.vcf.gz | 
\ awk 'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5,$6,a[1],$9,$10}'
```

- How many variant sites have been identified? 
- Was the site we studied earlier at 215,906,548 included? 
- Does this support our earlier conclusions regarding if this site is a true variant?
 
"QUAL" stands for quality scores which are PHRED-scaled values that estimate the probability the alternative allele is incorrect. The higher the QUAL score is, the more confidence there is in a base call. "ALT" stands for alternative allele. "." will be found in this column if there is no variant and in those cases "QUAL" represents the probability that the site does have a variant. By omitting "-v" from the command, we can view the call for our site of interest by including all nonvariant calls:

```bash
$ bcftools call -m NA12891_CEU_sample.vcf.gz | grep -v "^##" \ awk 'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5,$6,a[1],$9,$10}'
```

- What does the QUAL score for site 215,906,548 tell you about this site?
- Calculate the probability that this site is variant:(HINT: QUAL = 121837, Probability = 10^(-QUAL/10) * 100%))
 
VCF files have Format keys to sort the data which are described in the header. To view:

```bash
$ bcftools call -m NA12891_CEU_sample.vcf.gz > NA12891_CEU_sample_calls.vcf.gz
$ grep "FORMAT=<ID=GT" NA12891_CEU_sampple_calls.vcf.gz
```

- What does this format id correspond to?
- How about this format id?

```bash
$ grep "FORMAT=<ID=PL" NA12891_CEU_sample_calls.vcf.gz
```

### Base Alignment Quality
As we discussed before, one of the possible reasons for the misalignment in the region near position 215,906,547 is that it is a low complexity region consisting of G's and C's. Regions with issues like this can be studied by enabling the Base Alignment Quality (BAQ) tool that was disabled in earlier analyses. BAQ adjusts base qualities to reflect both the probability of an incorrect base call and the probability of a particular base being misaligned:

```bash
$ samtools mpileup -u -v --region 1:215906528-215906567 \ 
--fasta-ref human_g1k_v37.fasta NA12891_CEU_sample.bam > \ 
NA12891_CEU_sample_baq.vcf.gz
$ grep -v "^##" NA12891_CEU_sample_baq.vcf.gz | \ 
awk 'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5,$6,a[1],$9,$10}'
```

As you may have noticed, site 215,906,547 which was previously called as a variant site using the bcftools call command is no longer considered to be a variant site. BAQ downweighted thee bases around the low complexity region due to the higher probability that the bases were misaligned.
