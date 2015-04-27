for(i in c("f20","f40","f60","f80")){
  for(j in c("5x","10x","15x","20x")){
    for(k in c("5ind","10ind","20ind","30ind")){
      cat("~/polyfreqs-ms-data/tetra/",i,"/",j,"/",k,"\n",sep="",file="tetra-dirs.txt",append=TRUE)
    }
  }
}