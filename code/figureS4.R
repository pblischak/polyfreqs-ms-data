######################################################
# Figure S4
#
# Script for showing that the root mean squared error
# decreases when the number of individuals increases
# but isn't very different between a 10 fold increase
# in sequencing coverage
########################################################

library(ggplot2)

# Set up data frame for storing the RMSE values
df <- data.frame(ploidy=rep("octo",40),
                 coverage=rep(c("c10","c100"), each=20),
                 frequency=rep(c("f0.01", "f0.05","f0.1","f0.2","f0.4"),each=4),
                 individuals=rep(c("i5","i10","i20","i30"),10),
                 RMSE=rep(NA,40))

# Gotta love the quadruple for loop...
for(p in "octo"){
  for(i in c("f0.01","f0.05","f0.1","f0.2","f0.4")){
    for(j in c("c10","c100")){
      for(k in c("i5","i10","i20","i30")){
        table<-read.table(paste("./sim_data/",p,"-",i,"-",j,"-",k,"-mcmc.out",sep=""),header=T,row.names=1)
        
        # Get samples after burn-in (251-1000)
        tab_mcmc<-table[251:1000,]
        
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
df$coverage <- factor(df$coverage, levels=c('c10','c100'))
df$individuals <- factor(df$individuals, levels=c('i5','i10','i20','i30'))

# Plot as lines based on indivuals, color and group by frequency
figS4 <- ggplot(df, aes(x=individuals, y=RMSE, group=frequency)) + geom_line(aes(color=frequency), size=2) + guides(size="none")

# Now plot as facets based on individuals versus coverage
figS4_facet <- figS4 + facet_grid(. ~ coverage) + theme_bw(base_size=18) + xlab("Number of individuals") + theme(axis.title.x=element_text(vjust=-0.25))
print(figS4_facet)

# Save the plot as SVG/PDF (just change the file ending)
ggsave("figS4.svg", figS4_facet, height=120, width=169, units="mm", scale=2.5)
ggsave("figS4.pdf", figS4_facet, height=120, width=169, units="mm", scale=2.5)
