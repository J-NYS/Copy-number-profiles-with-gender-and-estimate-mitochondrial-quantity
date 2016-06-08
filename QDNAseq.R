args <- commandArgs(TRUE)

### R code from vignette source 'QDNAseq.Rnw' => MODIFIED
### Initiation
  library(BSgenome)
  library(matrixStats)
  library(CGHregions)
  library(QDNAseq)
  bins <- getBinAnnotations(binSize=15)

# Location
  WD <- getwd()
  print(WD)

### Reading File
  setwd(paste(args[2],"",sep=""))
  readCounts <- binReadCounts(bins, bamfiles=paste(args[1],"bam",sep="."))
  setwd(WD)
  
  dir.exists(args[1])
  setwd(paste(WD,"/",args[1],sep=""))

### Rawprofile
  png(paste(args[1],"rawprofile.png",sep="_"))
  plot(readCounts, logTransform=FALSE, ylim=c(-50, 200))
  highlightFilters(readCounts, logTransform=FALSE,
                   residual=TRUE, blacklist=TRUE)
  dev.off()

# BMENTEN, tijdelijke aanpassing: filter op alle chromosomen
  # readCounts <- applyFilters(readCounts, chromosomes=NA)
  readCounts <- applyFilters(readCounts) # Origineel

### Isobar
  png(paste(args[1],"isobar.png",sep="_"))
  isobarPlot(readCounts)
  dev.off()
  
  readCounts <- estimateCorrection(readCounts)

### Noise
  png(paste(args[1],"noise.png",sep="_"))
  noisePlot(readCounts)
  dev.off()
  
  readCounts <- applyFilters(readCounts, chromosomes=NA)
  copyNumbers <- correctBins(readCounts)
  copyNumbers
  copyNumbers <- normalizeBins(copyNumbers)
  copyNumbers <- smoothOutlierBins(copyNumbers)

### Profile
  png(paste(args[1],"profile.png",sep="_"))
  plot(copyNumbers)
  dev.off()

### Export -> .txt/.igv/.bed
  exportBins(copyNumbers, file=paste(args[1],"txt",sep="."))
  exportBins(copyNumbers, file=paste(args[1],"igv",sep="."), format="igv")
  exportBins(copyNumbers, file=paste(args[1],"bed",sep="."), format="bed")
  
  copyNumbers <- segmentBins(copyNumbers, transformFun="sqrt")
  copyNumbers <- normalizeSegmentedBins(copyNumbers)

### Segments
  png(paste(args[1],"segments.png",sep="_"))
  plot(copyNumbers)
  dev.off()

### Calls (CGHregions)
  library(CGHregions)
  copyNumbers <- callBins(copyNumbers)
  png(paste(args[1],"calls.png",sep="_"))
  plot(copyNumbers)
  dev.off()
  cgh <- makeCgh(copyNumbers)
  cgh


### OPTIONAL
### Calling aberrations with the following cutoffs:
# homozygous deletion < -2 < loss < -0.42 < normal < 0.32 gain < 2.32 	< amplification

# Read .bed file
  # BED <- read.table(file=paste(args[1],"bed",sep="."), sep="\t", header=FALSE, skip = 1)
  # names(BED) = c("chr","start","stop","location","log2Ratio","?")

# Cutoff locations
  # deletion <- BED$location[BED$log2Ratio < -2]
  # deletion

  # loss <- BED$location[BED$log2Ratio > -2 & BED$log2Ratio < -0.42]
  # loss
  
  # normal <- BED$location[BED$log2Ratio > -0.42 & BED$log2Ratio < 0.32]
  # normal
  
  # gain <- BED$location[BED$log2Ratio > 0.32 & BED$log2Ratio < 2.32]
  # gain
  
  # amplification <- BED$location[BED$log2Ratio > 2.32]
  # amplification

# Write to files
  # write.table(deletion, file = "Call_deletions.txt")
  # write.table(loss, file = "Call_losses.txt")
  # write.table(normal, file = "Call_normal.txt")
  # write.table(gain, file = "Call_gains.txt")
  # write.table(amplification, file = "Call_amplifications.txt")

# END R-SCRIPT_QDNAseq JNys
print("END R-SCRIPT_QDNAseq JNys")
