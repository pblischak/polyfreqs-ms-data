## Example data set and output for running **polyfreqs** on *Solanum tuberosum*

This example contains the data set for autotetraploid potato that we used in the manuscript to estimate heterozygosity and
asses model adequacy. The data set was acquired from the R package fitTetra (Vooripps *et al*., 2011).


## The data files

These 2 files contains the total number of sequencing reads for each individual at each locus and the number of reference reads. 
They are the input data for running **polyfreqs**.

- **potato_tot_reads.txt**
- **potato_ref_reads.txt** 

## The output files

These are the output files generate by our **polyfreqs** run. 
They are the files that are intended to be used for the example analysis presented in the supplement.

- **potato_mcmc.out**: the stored samples of the posterior allele frequencies written to file.
- **potato_map_genotypes.txt**: maximum *a posteriori* genotype estimate for each individual at each locus.
- **potato_het_obs.txt**: the posterior samples of per locus observed heterozygosity.
- **potato_het_exp.txt**: the posterior samples of per locus expected heterozygosity.

### References

Blischak PD, LS Kubatko and AD Wolfe. Accounting for genotype uncertainty in the estimation of allele frequencies in autopolyploids. *In revision*. bioRxiv, doi: <a href="http://dx.doi.org/10.1101/021907" target="_blank">http://dx.doi.org/10.1101/021907</a>.

Vooripps RE, G Gort, B Vosman. 2011. Genotype calling in tetraploid species from bi-allelic marker data using mixture models. *BMC Bioinformatics* **12**: 172.