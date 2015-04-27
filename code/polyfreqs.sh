#!/bin/bash

usage() {
	echo "usage: $0 -n num_ind -c cover -a allele_freq -p ploidy -f file_name"
	}
	
while getopts "n:c:a:p:f:" option;
do
	case "$option" in
		n) num_ind=$OPTARG ;;
		c) cover=$OPTARG ;;
		a) freq=$OPTARG ;;
		p) ploidy=$OPTARG ;;
		f) mcmcfile=$OPTARG ;;
		?)
			usage
			exit ;;
	esac
done

for i in `seq 1 100`
do

	Rscript polyfreqs.R $num_ind $cover $freq $mcmcfile $ploidy

	cp $mcmcfile p$i-$ploidy-mcmc.out

done