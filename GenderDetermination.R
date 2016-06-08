args <- commandArgs(TRUE)

reads <- read.csv(file=paste(args[2],"/",args[1],"reads.txt",sep=""), header = FALSE)
sexX <- read.csv(file=paste(args[2],"/",args[1],"sexX.txt",sep=""), header = FALSE)
sexY <- read.csv(file=paste(args[2],"/",args[1],"sexY.txt",sep=""), header = FALSE)

normX <- sexX$V1/reads$V1*100
write.table(normX, file = paste(args[1],"GenderDeterminationX.txt", sep="_"))

normY <- sexY$V1/reads$V1*100
write.table(normY, file = paste(args[1],"GenderDeterminationY.txt", sep="_"))

print("END R-SCRIPT_GenderDetermination JNys")