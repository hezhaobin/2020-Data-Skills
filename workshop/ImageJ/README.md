---
title: Analyzing fluorescence microscopy images with ImageJ
author: Bin He
date: 2020-04-15
---

# Reference & Credit
This workshop is entirely based on <https://petebankhead.gitbooks.io/imagej-intro/content/>. This markdown file provides miscellaneous notes I made while working through the tutorial. You should follow the original and only use this file as a troubleshooting guide.

# Set up your computer
You need the ImageJ software and the data associated with this tutorial. You don't have to use the [FastX](fastx.divms.uiowa.edu) environment, although it does have ImageJ pre-installed. To work on your own computer, simply [download](https://imagej.net/Fiji/Downloads) and install FIJI (FIJI Is Just ImageJ), which is built on top of ImageJ to provide many plugins for biological image analysis.

- Download Fiji, install and get familiar with its graphic user interface.
- Create a folder on your computer, e.g. `~/Documents/ImageJ-workshop`, and [download the data](https://github.com/petebankhead/imagej-intro/raw/master/practicals/Analyzing_fluorescence_images_data.zip) for this workshop. Unzip the downloaded file into the folder you just created.

# Images & Pixels
- What is a "pixel"?
- What's the difference between "data" and "display"? Why?
- Why images that _look the same_ can contain _different_ pixel values, while images that _look different_ can contain _the same_ pixel values?
    - Look at Figure 3 -- use the pixel intensity distribution to pick out "which two figures are identical".
- If you want to tell whether two images are identical, is comparing their histograms always a reliable method?

## Mapping colors to pixels
- What is a "Look-Up Table"?
- Why use different LUTs?
- How to adjust the display range in ImageJ?
    - Do the "Practical" exercise with the `spooked.tif` image. What "hidden" image did you see?
    - What's your understanding of "the 'best' contrast setting really depends upon what it is you want to see"
- Understand how scientific image analysis is NOT photo editing.
    - be wary that if you edit your scientific images in your favorite photo editing app, even professional ones like Photoshop, you could have changed the raw data and therefore inadvertently "manipulated" your data.

## Properties and pixel size
> This chapter ends with the other important characteristic of pixels for analysis: their size, and therefore how measuring or counting them might be related back to identifying the sizes and positions of things in real life. Sizes also need to be correct for much analysis to be meaningful.
- What is pixel size and why it is always important to check the "properties..." of your image?

# Dimensions
- Dimensions: the number of dimensions is the number of pieces of information you need to know to identify individual pixels.
    - what does this mean?
- What are stacks and hyperstacks?
