## Author: Jose Martin
## Date: November 2019


#! /bin/bash


## Reading input parameters
SAMPLE_ID=$1
WD=$2
NUM_SAMPLES=$3
SCRIPT=$4

## Debuging parameters
echo "Working directory:" $WD
echo "Number of samples:" $NUM_SAMPLES
echo "Path to scripts:" $SCRIPT

## Access samples folder
cd $WD/samples/sample_${SAMPLE_ID}

## QC
fastqc sample_${SAMPLE_ID}.fq.gz

## Mapping to reference genome
hisat2 --dta -x $WD/genome/genome -U sample_${SAMPLE_ID}.fq.gz -S sample_${SAMPLE_ID}.sam
samtools sort -o sample_${SAMPLE_ID}.bam sample_${SAMPLE_ID}.sam
rm sample_${SAMPLE_ID}.sam
samtools index sample_${SAMPLE_ID}.bam

## Ensamblado de transcritos
stringtie -G $WD/annotation/annotation.gtf -o sample_${SAMPLE_ID}.gtf -l sample_${SAMPLE_ID} sample_${SAMPLE_ID}.bam

## Preparing merge list file for transcriptome merging
echo $WD/samples/sample_${SAMPLE_ID}/sample_${SAMPLE_ID}.gtf >> $WD/results/merge_list.txt

## Gene Expression Quantification
stringtie -e -B -G $WD/annotation/annotation.gtf -o sample_${SAMPLE_ID}.gtf sample_${SAMPLE_ID}.bam

## Codigo de la pizarra-Punto de sincronizacion
echo sample_${SAMPLE_ID} "DONE" >> $WD/logs/blackboard_rnaseq.txt

DONE_SAMPLES=$(cat $WD/logs/blackboard_rnaseq.txt | grep "DONE" | wc -l)

## Tambien se podria haber hecho: DONE_SAMPLES=$(wc -l $WD/logs/blackboards_rnaseq.txt | awk '{ print $1 }')

echo "Done samples:" $DONE_SAMPLES


if [ $DONE_SAMPLES -eq $NUM_SAMPLES ]
then
   qsub -N transcriptome_merging -o $WD/logs/transcriptome $SCRIPT/transcriptome_merging.sh $WD
fi
