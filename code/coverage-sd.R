###################################
# Script for generating Figure 4.
#
# Requires ggplot2
###################################
library(ggplot2)

hex_c5 <- read.table("sim_data/hex-f0.2-c5-i30-mcmc.out",header=T, row.names=1)
hex_c10 <- read.table("sim_data/hex-f0.2-c10-i30-mcmc.out",header=T, row.names=1)
hex_c20 <- read.table("sim_data/hex-f0.2-c20-i30-mcmc.out",header=T, row.names=1)
hex_c50 <- read.table("sim_data/hex-f0.2-c50-i30-mcmc.out",header=T, row.names=1)
hex_c100 <- read.table("sim_data/hex-f0.2-c100-i30-mcmc.out",header=T, row.names=1)

cov_df <- data.frame(cov = factor(rep(c("c5","c10","c20","c50","c100"), each=100)), 
                     sd = c(apply(hex_c5[251:1000,],2,sd), 
                            apply(hex_c10[251:1000,],2,sd), 
                            apply(hex_c20[251:1000,],2,sd), 
                            apply(hex_c50[251:1000,],2,sd), 
                            apply(hex_c100[251:1000,],2,sd)))

cov_plot <- ggplot(cov_df, aes(x=sd, fill=cov)) + geom_density(alpha=0.6) + ggtitle("Effect of coverage on posterior standard deviation")
new_cov_plot <- cov_plot + theme(legend.title=element_blank(), axis.title.y = element_blank()) + xlab("Standard deviation") + scale_fill_discrete(breaks=c("c5","c10","c20","c50","c100"))
ggsave("coverage-sd.svg",plot=new_cov_plot,dpi=300)