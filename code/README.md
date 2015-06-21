# `code/`

This folder contains scripts for running the simulations conducted in Blischak et al. (2015). 
They include scripts for writing PBS batch files for submission to the Ohio Supercomputer, the scripts for running **polyfreqs** and for analyzing the output. 
A more detailed description of each file is below.

--------

## `write_polyfreqs_pbs.py`

`write_polyfreqs_pbs.py` is a simple python script for writing PBS style submission files for batch processing on high-powered computing (HPC) environments. 
The Ohio Supercomputer uses PBS with the qsub system but other systems may use a different type of submission format. 
The script writes all of the PBS files (.pbs in the `pbs_scripts/` folder) for the tetraploid and hexaploid simulations and also writes two bash scripts for submitting all of the jobs: 
*qsub_polyfreqs_tetra.sh* and *qsub_polyfreqs_hex.sh*.

It can be run using the following command:

```
python write_polyfreqs_pbs.py
```

--------

## `run_polyfreqs.sh` and `run_polyfreqs.R`

* **-i**    The number of individuals.
* **-f**    The allele frequency for the simulated locus.
* **-p**    The ploidy levels of individuals in the population.
* **-m**    The name of the output file containing the MCMC samples.
* **-c**    The average sequencing coverage per individual per locus.

```
bash run_polyfreqs.sh -i 20 -f 0.2 -p 4 -m mcmc.out -c 20
```

--------

## `calc_tetra_stats.R` and `calc_hex_stats.R`



```
R CMD batch calc_tetra_stats.R
R CMD batch calc_hex_stats.R
```


--------

## `pbs_scripts/`

A folder containing all of the PBS submission files (there are 200).

## `sim_data/`

The results of the MCMC analyses run using polyfreqs which are analyzed using the `calc_*_stats.R` scripts.