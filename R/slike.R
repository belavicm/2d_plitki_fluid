library("pracma")
for (i in dir("../output/",pattern = ".dat")) {
  cat(i," ")
  df<-as.matrix(read.table(paste0("../output/",i)))
  tiff(paste0("./slike/adv_ss2_",i,".tif"),res=100,height = 9,width = 9,units = "in")
  df<-rot90(df,3)
  filled.contour(df)
  dev.off()
}
