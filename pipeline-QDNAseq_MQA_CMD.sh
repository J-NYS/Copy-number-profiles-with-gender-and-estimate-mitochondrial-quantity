#!/bin/bash
#PBS -l nodes=1:ppn=4

# Read Sample name & Make Dir
	mkdir "$1"
	echo ""

# Using QDNAseq R script
	echo "Running Rscript_QDNAseq"
	Rscript QDNAseq.R $1 $2
	echo ""

# Mitochondrial Quantity analysis
	echo "Mitochondrial Quantity analysis"
	cd $2
	samtools view -cq 30 $1.bam > $1reads.txt
	samtools view -cq 30 $1.bam MT > $1readsMT.txt
	cd -; echo $?
	Rscript MitochondrialQuantityAnalyse.R $1 $2
	cd $2
	rm $1reads*
	cd -; echo $?
	mv *MitochondrialQuantityAnalyse.txt $1
	echo ""

# END SCRIPT
	echo "END SCRIPT JNys"