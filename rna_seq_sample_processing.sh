## Author: Jose Martin
## Date: November 2019


#! /bin/bash


##Reading input parameters
SAMPLE_ID=$1
WD=$2
NUM_SAMPLES=$3
## Access samples folder
cd $WD/samples/sample_${SAMPLE_ID}

## QC
fastqc sample_${SAMPLE_ID}.fq.gz 

## Mapping to reference genome
hisat2 --dta -x $WD/genome/index -U sample_${SAMPLE_ID}.fq.gz - S sample_${SAMPLE_ID}.sam

samtools sort -o sample_${SAMPLE_ID}.bam sample_${SAMPLE_ID}.sam

samtools index sample_${SAMPLE_ID}.bam

## Ensamblado de transcritos
stringtie -G $WD/annotation/annotation.gtf -o sample_${SAMPLE_ID}.gtf -l sample_${SAMPLE_ID} sample_${SAMPLE_ID}.bam

##Codigo de la pizarra-Punto de sincronizacion

echo sample_${SAMPLE_ID} "DONE" >> $WD/log/blackboard.txt

DONE_SAMPLES=$(wc -l $WD/log/blackboard.txt)

if [ $DONE_SAMPLES -eq $NUM_SAMPLES ]
then
   
fi
