#!/bin/bash
#PBS -l nodes=1:ppn=4

	clear

# Read Sample name & Make Dir
	echo "Give sample name without.bam"
	read NAME
	mkdir "$NAME"
	echo "Give path (location) BAM file (exp. /home/jnys/mapping )"
	read BAM
	echo ""

# Using QDNAseq R script
	echo "Running Rscript_QDNAseq"
	Rscript QDNAseq.R $NAME $BAM
	echo ""

# Mitochondrial Quantity analysis
	echo "Mitochondrial Quantity analysis"
	cd $BAM
	samtools view -cq 30 $NAME.bam > $NAMEreads.txt
	samtools view -cq 30 $NAME.bam MT > $NAMEreadsMT.txt
	cd -; echo $?
	Rscript MitochondrialQuantityAnalyse.R $NAME $BAM
	cd $BAM
	rm $NAMEreads*
	cd -; echo $?
	mv *MitochondrialQuantityAnalyse.txt $NAME
	echo ""

# END SCRIPT
	echo "END SCRIPT JNys"