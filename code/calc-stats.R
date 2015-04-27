dirs<-readLines("tetra-dirs.txt",n=-1)

for(i in dirs){
  
  filenames<-list.files(i,pattern="*.out",full.names=TRUE)
  tmp<-c()
  means<-rep(NA,length(filenames))
  
  for(k in 1:length(filenames)){
    tmp<-read.table(filenames[k],header=TRUE)
    means[k]<-mean(tmp$p[251:1000])
  }
  cat(means,sep="\n",file=as.character(paste(i,"/means.txt",sep="")))
  rmse<-sqrt(sum((means-0.2)**2)/100)
  cat(rmse,file=as.character(paste(i,"/rmse.txt",sep="")))
}
