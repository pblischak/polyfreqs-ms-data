######################################################
# Figure S2 & S3
#
# Script for calculating the difference between 
# allele frequencies estimated with polyfreqs and
# allele frequencies calculated as the ratio of
# reference and total reads (simple_freqs) for the
# potato data
######################################################
library(polyfreqs)
library(ggplot2)
library(reshape)

potato_post <- read.table("potato_output/potato_mcmc.out", row.names=1, header=T)
potato_tot <- read.table("raw_data/potato_tot_reads.txt", row.names=1, header=T)
potato_ref <- read.table("raw_data/potato_ref_reads.txt", row.names=1, header=T)

potato_simple_freqs <- simple_freqs(potato_tot, potato_ref)
potato_mean_freqs <- apply(potato_post[251:1000,], 2, mean)
names(potato_mean_freqs)<-names(potato_simple_freqs)

dfS2_tmp1 <- data.frame(simple=potato_simple_freqs,
                       polyfreqs=potato_mean_freqs)

dfS2_tmp2 <- dfS2_tmp1[order(dfS2_tmp1$polyfreqs),]

dfS2 <- melt(dfS2_tmp2, variable_name="method")

dfS2$locus <- as.factor(rep(1:384,2))


dfS2_tmp2$diff <- dfS2_tmp1$simple - dfS2_tmp1$polyfreqs


diff_plot <- ggplot(dfS2_tmp2, aes(x=diff)) + geom_density() + theme_bw() + xlab("Difference: simple - polyfreqs")
print(diff_plot)
ggsave("figS3.pdf", diff_plot)


dfS2$method <- factor(dfS2$method, levels=c('polyfreqs','simple'))

potato_plot_tmp <- ggplot(dfS2, aes(x=locus, y=value, color=method)) + geom_point(stat="identity") + scale_color_hue(h.start=40)
potato_plot <- potato_plot_tmp + theme_bw(base_size=18) + scale_x_discrete(breaks=NULL) + ylab("Allele frequency") + theme(axis.title.x=element_blank())
print(potato_plot)

ggsave("figS2.pdf", potato_plot, scale=2)