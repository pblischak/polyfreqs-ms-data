######################################################
# Figure S1 
#
#Script for calculating the difference between 
# allele frequencies estimated with polyfreqs and
# allele frequencies calculated as the ratio of
# reference and total reads (simple_freqs)
######################################################

library(ggplot2)

# Set up data frame for storing the RMSE values
dfS <- data.frame(ploidy=c(rep("tetra",100),rep("hex",100),rep("octo",100)),
                 frequency=rep(c(rep("f0.01",20),rep("f0.05",20),rep("f0.1",20),rep("f0.2",20),rep("f0.4",20)),3),
                 coverage=rep(c(rep("c5",4),rep("c10",4),rep("c20",4),rep("c50",4),rep("c100",4)),3),
                 individuals=rep(c("i5","i10","i20","i30"),75),
                 RMSE=rep(NA,300))

dfS_tmp1 <- cbind(data.frame(method=rep("polyfreqs",300)),dfS)
dfS_tmp2 <- cbind(data.frame(method=rep("ratio",300)),dfS)
df2 <- rbind(dfS_tmp1, dfS_tmp2)



# Gotta love the quadruple for loop...
for(p in c("tetra", "hex", "octo")){
  for(i in c("f0.01","f0.05","f0.1","f0.2","f0.4")){
    for(j in c("c5","c10","c20","c50","c100")){
      for(k in c("i5","i10","i20","i30")){
        
        table<-read.table(paste("./sim_data/",p,"-",i,"-",j,"-",k,"-mcmc.out",sep=""), 
                          header=T,row.names=1)
        
        # Get samples after burn-in (251-1000)
        tab_mcmc<-table[251:1000,]
        
        # Read in raw data. They have the ending mcmc-out but that was
        # just an artifact of how I ran stuff on the super computer.
        # It was simpler to just use the same filename and tack 'tot-' or 'ref-'
        # on the front.
        tot<-read.table(paste("./raw_data/tot-",p,"-",i,"-",j,"-",k,"-mcmc.out",sep=""),
                        header=T, row.names=1)
        
        # Replace missing data (i.e. individuals with no sequencing reads ) with NA
        tot[tot==0]<-NA
        
        ref<-read.table(paste("./raw_data/ref-",p,"-",i,"-",j,"-",k,"-mcmc.out",sep=""),
                        header=T, row.names=1)
        
       
        # Get point estimates of the allele frequencies
        ratio_means <- apply(ref/tot, 2, mean, na.rm=T)
        poly_means<-apply(tab_mcmc, 2, mean)
        
        
        # Get the mean squared error based on the underlying allele
        # frequency used for the simulation
        if(i=="f0.01"){
          poly_mse<-mean((poly_means - 0.01)^2)
          ratio_mse<-mean((ratio_means - 0.01)^2)
        } else if(i=="f0.05"){
          poly_mse<-mean((poly_means - 0.05)^2)
          ratio_mse<-mean((ratio_means - 0.05)^2)
        } else if(i=="f0.1"){
          poly_mse<-mean((poly_means - 0.1)^2)
          ratio_mse<-mean((ratio_means - 0.1)^2)
        } else if(i=="f0.2"){
          poly_mse<-mean((poly_means - 0.2)^2)
          ratio_mse<-mean((ratio_means - 0.2)^2)
        } else if(i=="f0.4"){
          poly_mse<-mean((poly_means - 0.4)^2)
          ratio_mse<-mean((ratio_means - 0.4)^2)
        } else {
          stop("Something went wrong!")
        }
        
        df2[df2$method=="polyfreqs" & df2$ploidy==p & df2$frequency==i & df2$coverage==j & df2$individuals==k,]$RMSE<-sqrt(poly_mse)
        df2[df2$method=="ratio" & df2$ploidy==p & df2$frequency==i & df2$coverage==j & df2$individuals==k,]$RMSE<-sqrt(ratio_mse)
      }
    }
  }
}

# Set up ordering of factors from smallest to largest
# for individuals and coverage
df2$coverage <- factor(df2$coverage, levels=c('c5','c10','c20','c50','c100'))
df2$individuals <- factor(df2$individuals, levels=c('i5','i10','i20','i30'))
df2$ploidy <- factor(df2$ploidy, levels=c('tetra','hex','octo'))

# Plot as a scatteroplot based on frequency, color & shape by ploidy using bw-scale
figS1 <- ggplot(df2, aes(x=coverage, y=RMSE)) + geom_point(aes(color=method), size=4, alpha=0.9, position=position_dodge(width=0.1)) + scale_color_hue(h.start=40)

# Now plot as facets based on individuals versus coverage
figS1_facet <- figS1 + facet_grid(individuals ~ frequency) + theme_bw(base_size=18) + theme(axis.title.x=element_blank())
print(figS1_facet)

# Save the plot as SVG/PDF (just change the file ending)
ggsave("figS1.pdf", figS1_facet, height=120, width=180, units="mm", scale=2.5)
