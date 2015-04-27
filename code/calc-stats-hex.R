###########################################################
# Hexaploid model simulations.
#
# Script for calculating means and std dev 
# for allele frequency estimation. Plots the results 
# as a heat map. Uses ggplot2, plyr, reshape.
############################################################

library(ggplot2)
library(plyr)
library(reshape)


cat("Frequency","Coverage","Num_Ind",paste("rep",1:100,sep=""),sep="\t",file="hex-means-df.txt")
cat("\n",file="hex-means-df.txt",append=TRUE)

for(i in c("f20","f40","f60","f80")){
  for(j in c("5x","10x","15x","20x")){
    for(k in c("5ind","10ind","20ind","30ind")){
      dir<-as.character(paste("./hex/",i,"/",j,"/",k,sep=""))
      filenames<-list.files(dir,pattern="*.out",full.names=TRUE)
      tmp<-c()
      means<-rep(NA,length(filenames))
      
      for(r in 1:length(filenames)){
        tmp<-read.table(filenames[r],header=TRUE)
        means[r]<-mean(tmp$p[251:1000])
      }
      cat(i,j,k,means,sep="\t",file="hex-means-df.txt",append=TRUE)
      cat("\n",file="hex-means-df.txt",append=TRUE)
    }
  }
}

# Read in means as a data frame and separate by underlying allele frequency

samps.df<-read.table("hex-means-df.txt",header=T)
samps.df20<-samps.df[(samps.df[,1]=="f20"),2:103]
samps.df40<-samps.df[(samps.df[,1]=="f40"),2:103]
samps.df60<-samps.df[(samps.df[,1]=="f60"),2:103]
samps.df80<-samps.df[(samps.df[,1]=="f80"),2:103]

std.dev20<-cbind(samps.df20[,1:2],apply(samps.df20[,3:102]-0.2,1,sd))
std.dev40<-cbind(samps.df40[,1:2],apply(samps.df40[,3:102]-0.4,1,sd))
std.dev60<-cbind(samps.df60[,1:2],apply(samps.df60[,3:102]-0.6,1,sd))
std.dev80<-cbind(samps.df80[,1:2],apply(samps.df80[,3:102]-0.8,1,sd))

# Melt dataframes and standardize to a scale with mean 0.

std.dev20m<-reshape::melt(std.dev20)
#std.dev20m<-plyr::ddply(std.dev20m, .(variable), transform, rescale = scale(value))

std.dev40m<-reshape::melt(std.dev40)
#std.dev40m<-plyr::ddply(std.dev40m, .(variable), transform, rescale = scale(value))

std.dev60m<-reshape::melt(std.dev60)
#std.dev60m<-plyr::ddply(std.dev60m, .(variable), transform, rescale = scale(value))

std.dev80m<-reshape::melt(std.dev80)
#std.dev80m<-plyr::ddply(std.dev80m, .(variable), transform, rescale = scale(value))

# plot heat maps

heat.map20<-ggplot2::ggplot(std.dev20m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(limits=c(0.03,0.12),low="grey98", high="black")
heat.map40<-ggplot2::ggplot(std.dev40m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(limits=c(0.03,0.12),low="grey98", high="black")
heat.map60<-ggplot2::ggplot(std.dev60m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(limits=c(0.03,0.12),low="grey98", high="black")
heat.map80<-ggplot2::ggplot(std.dev80m, aes(Num_Ind, Coverage)) + geom_tile(aes(fill = value), colour="white") + scale_fill_gradient(limits=c(0.03,0.12),low="grey98", high="black")

hex.plot20<-heat.map20 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("5ind","10ind","20ind","30ind"), expand=c(0,0)) + scale_y_discrete(limits=c("5x","10x","15x","20x"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())
hex.plot40<-heat.map40 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("5ind","10ind","20ind","30ind"), expand=c(0,0)) + scale_y_discrete(limits=c("5x","10x","15x","20x"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())
hex.plot60<-heat.map60 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("5ind","10ind","20ind","30ind"), expand=c(0,0)) + scale_y_discrete(limits=c("5x","10x","15x","20x"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())
hex.plot80<-heat.map80 + theme_grey(base_size = 10) + labs(x = "",y="") + scale_x_discrete(limits=c("5ind","10ind","20ind","30ind"), expand=c(0,0)) + scale_y_discrete(limits=c("5x","10x","15x","20x"),expand=c(0,0)) + theme(legend.title=element_blank(), axis.ticks = element_blank())

# Save as 3in x 2in svd files @ 300dpi

ggsave("hex.plot20.svg",plot=hex.plot20,width=3.25,height=2.25,units="in",dpi=300)
ggsave("hex.plot40.svg",plot=hex.plot40,width=3.25,height=2.25,units="in",dpi=300)
ggsave("hex.plot60.svg",plot=hex.plot60,width=3.25,height=2.25,units="in",dpi=300)
ggsave("hex.plot80.svg",plot=hex.plot80,width=3.25,height=2.25,units="in",dpi=300)
