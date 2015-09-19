##########################################
# Figure 3
# 
# Script for generating plot
# of observed and expected heterozygosity
# for potato data.
###########################################

library(ggplot2)

# Read in exp and obs het from files
het_obs_table <- read.table("potato_output/potato_het_obs.txt")
het_exp_table <- read.table("potato_output/potato_het_exp.txt")

# convert to matrices and discard 25% of
# the samples as burn-in
het_obs <- as.matrix(het_obs_table[251:1000,])
het_exp <- as.matrix(het_exp_table[251:1000,])

# Get multilocus estimates of exp and obs het.
# Remova NAs just in case
multi_het_obs <- apply(het_obs, 1, mean, na.rm=T)
multi_het_exp <- apply(het_exp, 1, mean, na.rm=T)

# Make the data frame for storing the heterozygosity estimates
het_df <- data.frame(heterozygosity=rep(c("obs", "exp"), each=750),
                     value=c(multi_het_obs, multi_het_exp))

# Make plot using ggplot
het_plot_tmp <- ggplot(het_df, aes(x=value, color=heterozygosity, fill=heterozygosity)) + geom_density() + scale_fill_grey() + scale_color_grey() + theme_bw(base_size=18)
het_plot <- het_plot_tmp + theme(axis.title.x=element_blank()) + ggtitle("Observed vs. Expected Heterozygosity") + guides(color=NULL) + xlim(0.37, 0.39)
print(het_plot)

# Save plot as SVG and PDF
ggsave("fig3.svg", het_plot)
ggsave("fig3.pdf", het_plot)
