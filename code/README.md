# `code/`

This folder contains scripts for running the simulations that were conducted for the paper. 
They include scripts for writing PBS batch files for submission to the Ohio Supercomputer, the scripts for running **polyfreqs** and for analyzing the output and 
scripts for generating figures. 
A more detailed description of each file is below.

--------

## write_polyfreqs_pbs.py

`write_polyfreqs_pbs.py` is a simple python script for writing PBS style submission files for batch processing on high-powered computing (HPC) environments. 
The Ohio Supercomputer uses PBS with the qsub system but other systems may use a different type of submission format. 
The script writes all of the PBS files (.pbs in the `pbs_scripts/` folder) for the tetraploid, hexaploid and octoploid simulations and also writes three bash scripts for submitting all of the jobs: 
`qsub_polyfreqs_tetra.sh`, `qsub_polyfreqs_hex.sh` and `qsub_polyfreqs_octo.sh`.

It can be run using the following command:

```
python write_polyfreqs_pbs.py
```


## run_polyfreqs.sh and run_polyfreqs.R

Make sure that you have **polyfreqs** installed before trying to use these scripts. 
Instructions for installing it can be found <a href="https://github.com/pblischak/polyfreqs" target="_blank">here</a>.

This pair of scripts can be used to simulate and analyze high throughput read count data using **polyfreqs**. 
The read count data are simulated under the model described in the **polyfreqs** manuscript.
The script inside of `run_polyfreqs.sh` can act as a wrapper for running `run_polyfreqs.R`. 
The R script can be run on its own, however, without the use of the bash script. 
Using the flags with the bash script is a bit easier than trying to remember the order of command line arguments for the R script.

* **-i**    The number of individuals.
* **-f**    The allele frequency for the simulated locus.
* **-p**    The ploidy levels of individuals in the population.
* **-m**    The name of the output file containing the MCMC samples.
* **-c**    The average sequencing coverage per individual per locus.

A simulation run can be initiated using the following command (make sure the the `run_polyfreqs.R` script is in the same folder):

```
bash run_polyfreqs.sh -i 20 -c 20 -f 0.2 -m mcmc.out -p 4
```

The equivalent command for using `run_polyfreqs.R` alone is:

```
Rscript run_polyfreqs.R 20 20 0.2 mcmc.out 4
```


## R scripts for figures

R packages needed: **polyfreqs**, **ggplot2**, **reshape**, **coda**, **Hmisc**.

These are the scripts for generating all of the figures in the manuscript and supplemental material. 
The R packages listed above need to be installed in order to run them. 

Running each script can be done by either sourcing them in an R session (e.g., `source("figure1.R")`) or running them using the command line:

```
Rscript figure1.R
```

We have also written a bash script, `make_figures.sh` which will make all of the figures for you automatically. 
It can be run in a terminal as follows:

```
bash make_figures.sh
```

## pbs_scripts/

A folder containing all of the PBS files used for submitting jobs to the Ohio Supercomputer (300 files).

## sim_data/

The results of the MCMC analyses run using **polyfreqs** (300 files).

## raw_data/

All of the raw simulated data sets and the data set for autotetraploid potato are in this folder (602 files).