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
- **Exercise**: correcting dimensions
    - Open `lost_dimensions.tif` in Fiji/ImageJ. Identify the correct dimensions so it displays properly. What's your conclusion?
- Presenting dimensions
    - Make sure you try the "orthogonal views" and the "3D viewer"
- Z-projections
    - what is z-projection and what use does it have?
    - try "Z-project" on the "lost_dimensions.tif", which you have corrected its dimensions before
    - think through the question on how different projection methods (sum/max/min) performs under the two conditions, namely the image contains 4 additional, out-of-focus slices or there are several very bright, isolated, randomly distributed outlier pixels
    - what problem might there be if you use projections to determine the distance between two features?

# Types & bit-depths
- What is "bit-depths" and how does it affect what pixel values can be?
- What range of values does an 8-bit image have?
- How about 16-bit?
- Answer the question about the possible types of the images
    - -5:
    - 140:
    - -3.5
- What do "clipping" and "rounding" mean in the context of images?
- Clipping can occur both during image processing and image acquisition. How?
- When acquiring an 8-bit unsigned integer image, is it fair to say your data is fine so long as you do not store pixel values \< 0 or \> 255?
- How does the bit-depths of the camera (detector) and the types of the image (e.g. 8-bit, 16-bit) together determine the possible pixel value ranges?

# Channels & colors
- Understand that channels can be used to store the intensity at each pixel for different colors, if the colors are "intrinsic", such as two different fluorescent labels in the cell.
- Understand the different approaches taken by "composite images" vs RGB images to encode color
- **Exercise** open the "Fluorescent Cells" file from `open sample images` menu, then use the `image/color/channel-tools...` to play with different ways to look at individual colors. You can either change the "composite" to "color", which will only show one color at a time, or you can keep the top dropdown menu in "composite", and tick or untick the individual color channels.
    - how does the "more..." option in the "channel-tools" affect the display of the image? Recall that the color displayed is determined by the Look-Up Table (LUT), while the file itself only stores the intensity value at each pixel for each channel (thus you can make the red channel look purple or even rainbow!)
- What is the main benefit of using RGB format? And what is the downside?
- **Exercise**: open both `Cell_composite.tif` and `Cell_RGB.tif` from the dataset you downloaded and unzipped. use the `Image/Color/Split channels` on both images and observe the output. Why are they different?
- Understand that our monitors almost always work with RGB.
- Understand that there are other "color spaces", such as CMYK -- printers usually work with this color space -- if you have replaced toner cartridges in a color printer, you may have noticed that the cartridges are black, cyan, yellow and blue.

# File & file formats
- Understand that you should always keep the originally acquired files -- and refer to the original acquisition software to confirm the metadata.
- Know that the LOCI Bioformats plugin (installed by default in Fiji) is a powerful tool to extract the metadata, (sometimes it has to guess the file format, and thus mistakes can be made)
- Understand the two main ways of image compression.
    - be suspitious and cautious when you see an image whose size is too small to be true -- perhaps it has been compresses with Lossy algorithm, leading to irreversible loss of information.
    - **If in doubt, avoid compression -- and really avoid JPEG for fluorescence microscopy**
- What's the difference between "bitmaps" and "vector images"?
- If you are up to the challenge, try to do the `Besenfreunde.ids` practice. Quite fun!
