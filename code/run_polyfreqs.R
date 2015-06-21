# R script for simulating read data and analyzing using
# the allele frequency model in polyfreqs. Simulaiton
# parameters are passed as command line arguments
# from the bash script 'run_polyfreqs.sh'.

args <- commandArgs(TRUE)

n_ind <- as.numeric(args[1])
coverage <- as.numeric(args[2])
freq <- as.numeric(args[3])
file <- as.character(args[4])
ploidy <- as.numeric(args[5])
error <- 0.01
library(polyfreqs)

# Simulate the read data
dat <- sim_reads(rep(freq,100), n_ind, coverage, ploidy, error)

# Run polyfreqs
polyfreqs(dat$tot_read_mat, dat$ref_read_mat, ploidy, 100000, thin=100, outfile=file)