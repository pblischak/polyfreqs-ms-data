# Tetraploid version of model of Buerkle and Gompert (2013; Mol. Ecol.)

# Read in and parse command line options

args<-commandArgs(TRUE)

n.ind<-as.numeric(args[1])
coverage<-as.numeric(args[2])
thin<-5000
burnin<-0.25
freq<-as.numeric(args[3])
file<-as.character(args[4])
error<-.01
R.mat<-rep(NA,n.ind)
Rb.mat<-rep(NA,n.ind)
genotypes<-rep(NA,n.ind)

# Simulate data from the model

for(i in 1:n.ind){
	genotypes[i]=rbinom(1,4,freq)
	R.mat[i]<-rpois(1,lambda=coverage)
	if(genotypes[i]==0){
		Rb.mat[i]<-rbinom(1,R.mat[i],error)
	} else if(genotypes[i]==1){
		Rb.mat[i]<-rbinom(1,R.mat[i],0.25)
	} else if(genotypes[i]==2){
		Rb.mat[i]<-rbinom(1,R.mat[i],0.5)
	} else if(genotypes[i]==3){
		Rb.mat[i]<-rbinom(1,R.mat[i],0.75)
	} else {
		Rb.mat[i]<-rbinom(1,R.mat[i],1-error)
	}
}

# Code for sampling new genotypes from the full
# conditional distribution P(gi|gi-,p,Rbi,epsilon).

get.genotype<-function(x,n,e,p){

  p0<-(e^x)*((1-e)^(n-x))*((1-p)^4)
  p1<-choose(4,1)*(.25^x)*(0.75^(n-x))*p*(1-p)^3
  p2<-choose(4,2)*(.5^n)*p^2*((1-p)^2)
  p3<-choose(4,3)*(.75^x)*(0.25^(n-x))*p^3*(1-p)
  p4<-((1-e)^x)*(e^(n-x))*(p^4)

  g<-sample(0:4,1,prob=(c(p0,p1,p2,p3,p4)/sum(p0,p1,p2,p3,p4)))

  return(g)
}


# Create mcmc-tetra-out file for storing sampled values of p.

cat("iter","\t","p\n",file=file)

# MCMC with Gibbs sampling for 500,000 generations thinned by 5,000.
# Print to the file p$i-tetra-mcmc.out

N<-length(Rb.mat)
N.iter<-500000
g.init<-sample(0:4,N,replace=TRUE)
p.init<-runif(1,0,1)
tot.reads<-sum(R.mat)
p.post<-c()
g.post<-matrix(rep(NA,N),nrow=N,ncol=1)
for(k in 1:N.iter){
	g.post<-mapply(get.genotype,Rb.mat,R.mat,error,p.init)
	p.post<-rbeta(1,sum(g.post)+1,sum(4-g.post)+1)
	p.init<-p.post
  if((k %% thin) == 0){
    cat(k,"\t",p.init,"\n",file=file,append=TRUE)
  }
}
