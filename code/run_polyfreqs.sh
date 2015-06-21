#!/bin/bash


while getopts "p:f:c:i:m:" option;
do
	case "$option" in
		p) ploidy=$OPTARG ;;
		f) freq=$OPTARG ;;
		c) cover=$OPTARG ;;
		i) ind=$OPTARG ;;
		m) mcmcfile=$OPTARG ;;
		?)
			usage
			exit ;;
	esac
done

	Rscript run_polyfreqs.R $ind $cover $freq $mcmcfile $ploidy