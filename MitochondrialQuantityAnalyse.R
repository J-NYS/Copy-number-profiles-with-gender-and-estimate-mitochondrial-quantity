args <- commandArgs(TRUE)

reads <- read.csv(file=paste(args[2],"/",args[1],"reads.txt",sep=""), header = FALSE)
readsMT <- read.csv(file=paste(args[2],"/",args[1],"readsMT.txt",sep=""), header = FALSE)

MQA <- readsMT$V1/reads$V1*1000000
write.table(MQA, file = paste(args[1],"MitochondrialQuantityAnalyse.txt", sep="_"))

print("END R-SCRIPT_MitochondrialQuantityAnalyse JNys")