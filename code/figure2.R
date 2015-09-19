###################################
# Script for generating Figure 2.
#
# Requires ggplot2 and Hmisc.
###################################
library(ggplot2)

# Read in data for hexaploid simulations
hex_c5 <- read.table("sim_data/hex-f0.2-c5-i30-mcmc.out",header=T, row.names=1)
hex_c10 <- read.table("sim_data/hex-f0.2-c10-i30-mcmc.out",header=T, row.names=1)
hex_c20 <- read.table("sim_data/hex-f0.2-c20-i30-mcmc.out",header=T, row.names=1)
hex_c50 <- read.table("sim_data/hex-f0.2-c50-i30-mcmc.out",header=T, row.names=1)
hex_c100 <- read.table("sim_data/hex-f0.2-c100-i30-mcmc.out",header=T, row.names=1)

# Make data frame containing the standard deviations after burn-in for the posterior
# distributions of allele frequencies
cov_df <- data.frame(cov = factor(rep(c("c5","c10","c20","c50","c100"), each=100)), 
                     sd = c(apply(hex_c5[251:1000,],2,sd), 
                            apply(hex_c10[251:1000,],2,sd), 
                            apply(hex_c20[251:1000,],2,sd), 
                            apply(hex_c50[251:1000,],2,sd), 
                            apply(hex_c100[251:1000,],2,sd)))


# Plot the distribution of sd as a violoin plot
cov_plot <- ggplot(cov_df, aes(x=cov, y=sd)) + geom_violin(fill="grey90",trim=FALSE) + ggtitle("Effect of coverage on posterior standard deviation") + guides(fill=FALSE)
			
# Modify axes, labels and add summary stat plots of means (as dots) and vertical lines.
new_cov_plot <- cov_plot + theme_bw(base_size=14) + theme(axis.title.x = element_blank()) + ylab("Standard deviation") + scale_x_discrete(limits=c("c5","c10","c20","c50","c100")) + stat_summary(fun.data="mean_sdl", mult=1, geom="pointrange", width=0.2, color="grey20") + stat_summary(fun.y=mean, colour="black", width=2, geom="line", aes(group="c5"))
				
# Save as SVG
ggsave("fig2.svg",plot=new_cov_plot,dpi=300)
ggsave("fig2.pdf",plot=new_cov_plot,dpi=300)

