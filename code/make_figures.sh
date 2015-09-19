#!/bin/bash

# This is a bash script for making all of the figures.
# It's pretty simple really. It just loops through all of the R
# files that are named figure#.R and executes them using Rscript.


for file in figure*.R; do
	Rscript $file
done