#!/bin/bash
#PBS -l nodes=1:ppn=4

# Read Sample name & Make Dir
	mkdir "$1"
	mkdir GenderDetermination
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
	cd -; echo $?
	mv *MitochondrialQuantityAnalyse.txt $1
	echo ""

# Gender Determitation
	echo "Gender Determitation"
#	cd $2
	samtools view -cq 30 $1.bam X > $1sexX.txt
	samtools view -cq 30 $1.bam Y > $1sexY.txt
	cd -; echo $?
	Rscript GenderDetermination.R $1 $2
	cd $2
	rm $1reads* $1sex*
	cd -; echo $?
	mv *GenderDeterminationX.txt /home/projects/PGD_Stage_Jens/resultaten/GenderDetermination	
	mv *GenderDeterminationY.txt /home/projects/PGD_Stage_Jens/resultaten/GenderDetermination
	echo ""

# END SCRIPT
	echo "END SCRIPT JNys"
