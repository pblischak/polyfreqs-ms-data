######################################################
# Script for calculating root mean square error
# for allele frequency estimation (Figure 1)
######################################################

library(ggplot2)
library(coda)

# Set up data frame for storing the RMSE values
df <- data.frame(ploidy=c(rep("tetra",100),rep("hex",100),rep("octo",100)),
                 frequency=rep(c(rep("f0.01",20),rep("f0.05",20),rep("f0.1",20),rep("f0.2",20),rep("f0.4",20)),3),
                 coverage=rep(c(rep("c5",4),rep("c10",4),rep("c20",4),rep("c50",4),rep("c100",4)),3),
                 individuals=rep(c("i5","i10","i20","i30"),75),
                 RMSE=rep(NA,300))

# Gotta love the quadruple for loop...
for(p in c("tetra", "hex", "octo")){
  for(i in c("f0.01","f0.05","f0.1","f0.2","f0.4")){
    for(j in c("c5","c10","c20","c50","c100")){
      for(k in c("i5","i10","i20","i30")){
        table<-read.table(paste("./sim_data/",p,"-",i,"-",j,"-",k,"-mcmc.out",sep=""),header=T,row.names=1)
        
        # Get samples after burn-in (251-1000)
        tab_mcmc<-mcmc(table[251:1000,])
        
        # Check that effective sample sizes are greater than 200
        # ESS not the greatest indicator but there are 30,000 runs to check
        cat(sum(effectiveSize(tab_mcmc) < 200),"\n")
        
        # Get the posterior means
        means<-apply(tab_mcmc, 2, mean)
        
        # Get the mean squared error based on the underlying allele
        # frequency used for the simulation
        if(i=="f0.01"){
          mse<-mean((means - 0.01)^2)
        } else if(i=="f0.05"){
          mse<-mean((means - 0.05)^2)
        } else if(i=="f0.1"){
          mse<-mean((means - 0.1)^2)
        } else if(i=="f0.2"){
          mse<-mean((means - 0.2)^2)
        } else if(i=="f0.4"){
          mse<-mean((means - 0.4)^2)
        } else {
          stop("Something went wrong!")
        }
        
        
        # Take the square root to get RMSE and put in the data frame
        df[df$ploidy==p & df$frequency==i & df$coverage==j & df$individuals==k,]$RMSE<-sqrt(mse)
      }
    }
  }
}


# Set up ordering of factors from smallest to largest
# for individuals and coverage
df$coverage <- factor(df$coverage, levels=c('c5','c10','c20','c50','c100'))
df$individuals <- factor(df$individuals, levels=c('i30','i20','i10','i5'))
df$ploidy <- factor(df$ploidy, levels=c('tetra','hex','octo'))

# Plot as a scatteroplot based on frequency, color & shape by ploidy using bw-scale
fig1 <- ggplot(df, aes(x=frequency, y=RMSE)) + geom_point(aes(color=ploidy, shape=ploidy), size=4, alpha=0.9, position=position_dodge(width=0.1)) + scale_color_grey()

# Now plot as facets based on individuals versus coverage
fig1_facet <- fig1 + facet_grid(individuals ~ coverage) + theme_bw(base_size=18) + theme(axis.title.x=element_blank())
print(fig1_facet)

# Save the plot as SVG/PDF (just change the file ending)
ggsave("fig1.svg", fig1_facet, height=120, width=169, units="mm", scale=2.5)
ggsave("fig1.pdf", fig1_facet, height=120, width=169, units="mm", scale=2.5)
