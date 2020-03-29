---
title:
author:
date:
---

Genomics Workshop
=================

## Before we start

- This workshop is entirely based on <https://datacarpentry.org/wrangling-genomics/>
- This workshop is intended to be completed on the ARGON computing cluster at the University of Iowa.
    a. if you are working off campus, first download and connect to VPN, following the instructions [here](https://its.uiowa.edu/vpn)
    b. if your personal computer is Windows-based and not set up for terminal access, log on to the fastx environment in your browser window.
    c. to connect to ARGON, use `$ ssh -Y <HawkID>@argon.hpc.uiowa.edu`. You will need to have 2-step verification set up.
- Clone this repository
    ```bash
    $ cd
    $ git clone https://github.com/hezhaobin/2020-Data-Skills.git
    ```

## Setup

Instructions based on <https://datacarpentry.org/genomics-workshop/setup.html>

### Install software

1. Preparation
    I suggest you create a folder named "sw" to contain all of your custom-installed software on ARGON
    ```sh
    $ cd # go to your home directory
    $ mkdir sw; cd sw # create and enter the sw folder
    ```
1. FastQC
    This is a commonly used quality checking program for FASTQ files
    ```sh
    $ wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
    $ unzip fastqc_v0.11.9.zip
    $ cd FastQC # tab don't type. your folder may have a different name
    $ chmod 755 fastqc # this makes the wrapper code executable
    ```
1. MultiQC
    This is a tool that can aggregate FastQC results for individual fastq files
    ```bash
    $ module load python/3.7.0 # this loads the Python version 3.7.0
    $ pip install --user multiqc # --user tells pip to install the software into the user's directory, instead of the system directory
    $ multiqc -h # if you see the help menu, it tells you that your installation is successful
    ```
1. Trimmomatic
    [A good introduction](https://wikis.utexas.edu/display/CoreNGSTools/Pre-processing+raw+sequences#Pre-processingrawsequences-TrimmingsequencesTrimming) to why you would want to trim your reads before downstream analysis.
    ```sh
    $ cd ~/sw
    $ wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
    $ cd Trimmomatic-0.39
    $ java -jar trimmomatic-0.39.jar # if you see the options for the program, that means installation is successful
    ```

### Download data

```bash
# first, cd into the data folder
# $ wget -O 7726454.zip https://ndownloader.figshare.com/articles/7726454/versions/2
$ cd ~/2020-Data-Skills/workshop/genomics-workshop/script
$ sh download_fastq.sh
$ ls ../data/untrimmed_fastq # check to make sure that there are 6 .fastq.gz files in the folder
```

## Analysis
### Understand the data structure and format

It is important to understand the setup of the experiment and how the data is organized before you analyze it. This applies to both your own data and other people's data.

1. Download and view the metadata
   ```sh
   # change to the workshop's directory
   $ cd data
   $ wget https://raw.githubusercontent.com/datacarpentry/wrangling-genomics/gh-pages/files/Ecoli_metadata_composite.csv
   $ head Ecoli_metadata_composite.csv | column -t -s "," # this is an easy (imperfect) way to format a csv file for viewing
   $ module load R # let's examine it using R
   $ R
   ```
   ```r
   > meta <- read.csv("Ecoli_metadata_composite.csv", header=TRUE)
   ```

   Based on the metadata, can you answer the following questions?

   - How many different generations exist in the data?
       `> table(meta$generation)`
   - How many rows and how many columns are in this data?
       `> dim(meta)`
   - How many citrate+ mutants have been recorded in Ara-3?
       `> table(meta$cit)`
   - How many hypermutable mutants have been recorded in Ara-3?
       `> table(meta$mutator)`


1. Examine the FASTQ format
    - if you are still in R, use `q('no')` to quit
    ```bash
    $ cd untrimmed_fastq # tab, don't type. if double tab still doesn't show the untrimmed_fastq folder, check where you are by typing `pwd`
    $ zcat SRR2584866_1.fastq.gz | head # this shows you the first 10 lines of the fastq file. it should look familiar to you now, right?
    ```

### Quality control
**It is always important to know the quality of your data, not just nextgen sequencing, but ANY data**

We will use FastQC, a java program that is very popular in the nextgen sequencing analysis community. You should have downloaded and unpacked the program in the set up part. Now let's test it

#### Learn about FastQC
```bash
$ ~/sw/FastQC/fastqc -h # tab, don't type. if you get an error, make sure that you have installed the program correctly, and have made the script executable
```

What did you learn from the help menu?

#### Assessing quality using FastQC
1. Make sure that you are in the `untrimmed_fastq` directory. Check by `pwd` and `ls`. Make sure that you can see the `<name>.fastq.gz` files
1. Run FastQC on all fastq files
    ```bash
    $ ~/sw/FastQC/fastqc *.fastq* # tab don't type, except for the last part. wild cards disables tab complete
    $ mkdir ../../output/fastqc   # create a folder in the output directory to store all fastqc results
    $ mv *fastqc* ../../output/fastqc # tab don't type! move the results to the newly created folder
    $ cd ../../output/fastqc      # change directory to the output results
    $ multiqc .                   # this runs multiqc
    ```
1. Now, to view the results, we need a graphic user interface. You have two options here (it's ok if you didn't get this part to work, but give it a try):
    a. Map your Argon home account directory locally, follow this [instruction](https://wiki.uiowa.edu/display/hpcdocs/Home+Accounts), which you have learned before. Then navigate to the folder that contains the `output/fastqc` and copy the results to your local directory, and view the `multiqc_report.html`
    b. Secure copy the results to your local computer
        ```bash
	# first open a new terminal window, not the one that you used to connect to ARGON
	$ mkdir -p ~/tmp/fastqc; cd ~/tmp/fastqc   # create a temporary folder to hold the results
	$ rsync -avz -e ssh <HawkID>@argon.hpc.uiowa.edu:~/2020-Data-Skills/workshop/genomics-workshop/output/fastqc/ ./
	# if the rsync command fails, one possibility is that your directory is different from ~/2020-Data-Skills/... 
	```

1. View the text output
    If you had trouble downloading the files either using mapped drive or with `rsync`, know that you can also rely on the plain text output
    Now go back to your terminal with the ARGON session
    ```bash
    $ pwd # check where you are. if necessary, cd into the `genomics-workshop` folder
    $ mkdir docs # create a new level 1 folder to contain important documentation
    $ cd docs
    $ ln -s ../output/fastqc/multiqc_data/multiqc_fastqc.txt ./ # this creates a "shortcut" to a summary file produced by multiqc
    $ column -ts $'\t' multiqc_fastqc.txt | less -S # this prints the content of the file in a pretty format
    ```

### Trimming and Filtering
_Why do we need to trim the reads?_

The answer below is from [this website](https://wikis.utexas.edu/display/CoreNGSTools/Pre-processing+raw+sequences#Pre-processingrawsequences-TrimmingsequencesTrimming)

> There are two main reasons you may want to trim your sequences:
> 
> - As a quick way to remove 3' adapter contamination, when extra bases provide little additional information
>     - For example, 75+ bp ChIP-seq reads – 50 bases are more than enough for a good mapping, and trimming to 50 is easier than adapter removal, especially for paired end data.
>     - You would not choose this approach for RNA-seq data, where 3' bases may map to a different exon, and that is valuable information.
>         - Instead you would specifically remove adapter sequences.
> - Low quality base reads from the sequencer can cause an otherwise mappable sequence not to align
>     - This is more of an issue with sequencing for genome assembly – both bwa and bowtie2 seem to do fine with a few low quality bases, soft clipping them if necessary.

_Running Trimmomatic_

1. Copy the program and adapter sequence to the data folder
    ```bash
    $ pwd # notice where you are. if necessary, change directory to `untrimmed_fastq`
    $ cp ~/sw/Trimmomatic-0.39/trimmomatic-0.39.jar ./ # Tab don't type! Your folder name may be different from mine
    $ cp ~/sw/Trimmomatic-0.39/adapters/NexteraPE-PE.fa ./
    $ java -jar ./trimmomatic-0.39.jar PE SRR2589044_1.fastq.gz SRR2589044_2.fastq.gz \
                                          SRR2589044_1.trim.fastq.gz SRR2589044_1un.trim.fastq.gz \
                                          SRR2589044_2.trim.fastq.gz SRR2589044_2un.trim.fastq.gz \
				          SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 
    ```

    - For detailed explanation of the `trimmomatic` command above, see the author's [website](http://www.usadellab.org/cms/?page=trimmomatic)
    - Follow the [workshop website](https://datacarpentry.org/wrangling-genomics/03-trimming/index.html) to examine the output and answer the questions
        - What percent of reads did we discard from our sample? 2) What percent of reads did we keep both pairs?
        - What are the output files? How large are they compared to the input files, why?

1. Now let's try to automate the trimming by writing a script and submitting it to the ARGON scheduler
    First, let's create a file that records all the sample IDs so we can loop through them in a script

    ```bash
    # you should still be in the `untrimmed_fastq` folder. If not, cd into it
    $ for f in *_1.fastq.gz; do echo $(basename $f _1.fastq.gz); done > SRR_ID.txt
    $ cat SRR_ID.txt # you should see three lines, each containing the "base name" of the sample starting with SRR
    # now you can go to the `../../script` folder, edit and run the `trimmomatic.sh`
    $ cd ../../script
    $ vim trimmomatic.sh # tab don't type!
    ```
    Now try to understand what the script does. To submit the job, enter `$ qsub -t 1-3 trimmomatic.sh`, where 1-3 means there are 3 files to submit.

    Use `qstat -u <HawkID>` to check the status of your job. If the job finishes, you can use `qacct -j <JOB_ID>` to view the resource usage of your job. Also check the job output and standard error in the `job-log` folder.

