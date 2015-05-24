# **polyfreqs-ms-data**: scripts and data for polyfreqs manuscript (see preprint on bioRxiv)

**polyfreqs** is an R package implementing a Gibbs sampler for estimating biallelic SNP frequencies in a population of polyploids. 
See Blischak *et al*. (2015) for more details on the model.

## Getting the scripts

## 'doc/'

The 'doc/' folder contains all of the files associated with the manuscript for the **polyfreqs** model, including the original TeX 
file. The document can be recreated (with an appropriate LaTeX distribution) with the following series of commands:

'''bash
pdflatex polyfreqs-ms
bibtex polyfreqs-ms
pdflatex polyfreqs-ms
pdflatex polyfreqs-ms
'''

## 'code/'

This directory has all of the summary data (means of means) for the posterior distributions of allele frequencies for the 

## 'fig/'

Contains all of the figures for the manuscript in raw format (i.e., prior to manipulation in Inkscape).