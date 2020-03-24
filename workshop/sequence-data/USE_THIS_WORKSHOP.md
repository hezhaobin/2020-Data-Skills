---
title: Workshop in markdown
author: Bin He, Leslie Speight
date: 2020-03-24
---

Working with Sequence Data Tuesday Workshop 
===========================================
Leslie Speight and Anna Ward

## Get data
Go to fastx or your laptop home directory (or wherever you prefer to store 
the workshop data, and clone the following repository

```bash
$ cd <path/to/workshop> # replace the second part with your directory name
$ git clone https://github.com/hezhaobin/2020-Data-Skills.git
$ cd 2020-Data-Skills/workshop/seqeunce-data/ # hint: Tab don’t type!
$ ls
```
    
Next open Rstudio and install required packages

```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install('qrqc')
# This is a Bioconductor package and helps us to visualize quality distribution across bases in reads
# Now you can minimize the RStudio window and get back to the terminal

```
