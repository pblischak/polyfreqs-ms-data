args<-commandArgs(TRUE)

n.ind<-as.numeric(args[1])
coverage<-as.numeric(args[2])
thin<-5000
freq<-as.numeric(args[3])
file<-as.character(args[4])
ploidy<-as.character(args[5])
error<-.01
R.mat<-rep(NA,n.ind)
Rb.mat<-rep(NA,n.ind)
genotypes<-rep(NA,n.ind)

if(ploidy=="tetra"){
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
  g.post<-matrix(rep(NA,N.iter*N),nrow=N,ncol=1)
  for(k in 1:N.iter){
    g.post<-mapply(get.genotype,Rb.mat,R.mat,error,p.init)
    p.post<-rbeta(1,sum(g.post)+1,sum(4-g.post)+1)
    p.init<-p.post
    if((k %% thin) == 0){
      cat(k,"\t",p.init,"\n",file=file,append=TRUE)
    }
  }
}else if(ploidy=="hex"){
  # Simulate data from the model
  
  for(i in 1:n.ind){
    genotypes[i]<-rbinom(1,6,freq)
    R.mat[i]<-rpois(1,lambda=coverage)
    if(genotypes[i]==0){
      Rb.mat[i]<-rbinom(1,R.mat[i],error)
    } else if(genotypes[i]==1){
      Rb.mat[i]<-rbinom(1,R.mat[i],(1/6))
    } else if(genotypes[i]==2){
      Rb.mat[i]<-rbinom(1,R.mat[i],(2/6))
    } else if(genotypes[i]==3){
      Rb.mat[i]<-rbinom(1,R.mat[i],(3/6))
    } else if(genotypes[i]==4){
      Rb.mat[i]<-rbinom(1,R.mat[i],(4/6))
    } else if(genotypes[i]==5){
      Rb.mat[i]<-rbinom(1,R.mat[i],(5/6))
    } else {
      Rb.mat[i]<-rbinom(1,R.mat[i],1-error)
    }
  }
  
  # Code for sampling new genotypes from the full
  # conditional distribution P(gi|gi-,p,Rbi,epsilon).
  
  get.genotype<-function(x,n,e,p){
    
    p0<-(e^x)*((1-e)^(n-x))*((1-p)^6)
    p1<-choose(6,1)*((1/6)^x)*((5/6)^(n-x))*p*((1-p)^5)
    p2<-choose(6,2)*((2/6)^x)*((4/6)^(n-x))*p^2*((1-p)^4)
    p3<-choose(6,3)*((3/6)^x)*((3/6)^(n-x))*p^3*((1-p)^3)
    p4<-choose(6,4)*((4/6)^x)*((2/6)^(n-x))*p^4*((1-p)^2)
    p5<-choose(6,5)*((5/6)^x)*((1/6)^(n-x))*p^5*((1-p))
    p6<-((1-e)^x)*(e^(n-x))*(p^6)
    
    g<-sample(0:6,1,prob=(c(p0,p1,p2,p3,p4,p5,p6)/sum(p0,p1,p2,p3,p4,p5,p6)))
    
    return(g)
  }
  
  # Create mcmc-hex-out file for storing sampled values of p.
  
  cat("iter","\t","p\n",file=file)
  
  # MCMC with Gibbs sampling for 500,000 generations thinned by 5,000.
  # Print to the file p$i-hex-mcmc.out.
  
  N<-length(Rb.mat) 
  N.iter<-500000
  g.init<-sample(0:6,N,replace=TRUE)
  p.init<-runif(1,0,1)
  tot.reads<-sum(R.mat)
  p.post<-c()
  g.post<-matrix(rep(NA,N.iter*N),nrow=N,ncol=1)
  for(k in 1:N.iter){
    g.post<-mapply(get.genotype,Rb.mat,R.mat,error,p.init)
    p.post<-rbeta(1,sum(g.post)+1,sum(6-g.post)+1)
    p.init<-p.post
    if((k %% thin) == 0){
      cat(k,"\t",p.init,"\n",file=file,append=TRUE)
    }
  }
} else {
  stop("Invalid ploidy specified. Only 'tetra' or 'hex' permited.")
}