###########################################################
# Tetraploid model simulations. 
#
# Script for calculating means and std dev 
# for allele frequency estimation. Plots the results 
# as a heat map. Uses ggplot2, plyr, reshape.
############################################################

library(ggplot2)
library(plyr)
library(reshape)


cat("Frequency","Coverage","Num_Ind",paste("rep",1:100,sep=""),sep="\t",file="tetra-means-df.txt")
cat("\n",file="tetra-means-df.txt",append=TRUE)

for(i in c("f0.01","f0.05","f0.1","f0.2","f0.4")){
  for(j in c("c5","c10","c20","c50","c100")){
    for(k in c("i5","i10","i20","i30")){
      table<-read.table(paste("./sim_data/tetra-",i,"-",j,"-",k,"-mcmc.out",sep=""),header=T,row.names=1)
      means<-apply(table[251:1000,],2,mean)
      cat(i,j,k,means,sep="\t",file="tetra-means-df.txt",append=TRUE)
      cat("\n",file="tetra-means-df.txt",append=TRUE)
    }
  }
}

# Read in means as a data frame and separate by underlying allele frequency

samps.df<-read.table("tetra-means-df.txt",header=T)
samps.df0.01<-samps.df[(samps.df[,1]=="f0.01"),2:103]
samps.df0.05<-samps.df[(samps.df[,1]=="f0.05"),2:103]
samps.df0.1<-samps.df[(samps.df[,1]=="f0.1"),2:103]
samps.df0.2<-samps.df[(samps.df[,1]=="f0.2"),2:103]
samps.df0.4<-samps.df[(samps.df[,1]=="f0.4"),2:103]

std.dev0.01<-cbind(samps.df0.01[,1:2],apply(samps.df0.01[,3:102]-0.01,1,sd))
std.dev0.05<-cbind(samps.df0.05[,1:2],apply(samps.df0.05[,3:102]-0.05,1,sd))
std.dev0.1<-cbind(samps.df0.1[,1:2],apply(samps.df0.1[,3:102]-0.1,1,sd))
std.dev0.2<-cbind(samps.df0.2[,1:2],apply(samps.df0.2[,3:102]-0.2,1,sd))
std.dev0.4<-cbind(samps.df0.4[,1:2],apply(samps.df0.4[,3:102]-0.4,1,sd))

# Melt dataframes and standardize to a scale with mean 0.

std.dev0.01m<-reshape::melt(std.dev0.01)
#std.dev20m<-plyr::ddply(std.dev20m, .(variable), transform, rescale = scale(value))

std.dev0.05m<-reshape::melt(std.dev0.05)
#std.dev40m<-plyr::ddply(std.dev40m, .(variable), transform, rescale = scale(value))

std.dev0.1m<-reshape::melt(std.dev0.1)
#std.dev60m<-plyr::ddply(std.dev60m, .(variable), transform, rescale = scale(value))

std.dev0.2m<-reshape::melt(std.dev0.2)
#std.dev80m<-plyr::ddply(std.dev80m, .(variable), transform, rescale = scale(value))

std.dev0.4m<-reshape::melt(std.dev0.4)

# plot heat maps

heat.map0.01<-ggplot2::ggplot(std.dev0.01m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(low="grey98", high="black")
heat.map0.05<-ggplot2::ggplot(std.dev0.05m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(low="grey98", high="black")
heat.map0.1<-ggplot2::ggplot(std.dev0.1m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(low="grey98", high="black")
heat.map0.2<-ggplot2::ggplot(std.dev0.2m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(low="grey98", high="black")
heat.map0.4<-ggplot2::ggplot(std.dev0.4m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(low="grey98", high="black")

tetra.plot0.01<-heat.map0.01 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("i5","i10","i20","i30"), expand=c(0,0)) + scale_y_discrete(limits=c("c5","c10","c20","c50","c100"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())
tetra.plot0.05<-heat.map0.05 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("i5","i10","i20","i30"), expand=c(0,0)) + scale_y_discrete(limits=c("c5","c10","c20","c50","c100"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())
tetra.plot0.1<-heat.map0.1 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("i5","i10","i20","i30"), expand=c(0,0)) + scale_y_discrete(limits=c("c5","c10","c20","c50","c100"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())
tetra.plot0.2<-heat.map0.2 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("i5","i10","i20","i30"), expand=c(0,0)) + scale_y_discrete(limits=c("c5","c10","c20","c50","c100"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())
tetra.plot0.4<-heat.map0.4 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("i5","i10","i20","i30"), expand=c(0,0)) + scale_y_discrete(limits=c("c5","c10","c20","c50","c100"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())

# Save as 3in x 2in svd files @ 300dpi

ggsave("tetra.plot0.01.svg",plot=tetra.plot0.01,dpi=300)
ggsave("tetra.plot0.05.svg",plot=tetra.plot0.05,dpi=300)
ggsave("tetra.plot0.1.svg",plot=tetra.plot0.1,dpi=300)
ggsave("tetra.plot0.2.svg",plot=tetra.plot0.2,dpi=300)
ggsave("tetra.plot0.4.svg",plot=tetra.plot0.4,dpi=300)
