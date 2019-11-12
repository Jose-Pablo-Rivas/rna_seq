## This pipeline analysis RNA-seq data

## Author: Jose Martin Perez Rivas
## Date: October 2019
## Tlf: josrivfer1@alum.us.es

#! /bin/bash

if [ $# -eq 0 ]
  then
   echo "This pipeline analysis RNA-seq data"
   echo "Usage: piperna <param_files>"
   echo ""
   echo "param_file: file with the parameters specifications. Please, check test/params.txt for an example"
   echo ""
   echo "enjoy"

   exit 0
fi


## Parameters loadings

PARAMS=$1

WD=$(grep working_directory: $PARAMS | awk '{ print $2 }' )
NS=$(grep number_of_samples: $PARAMS | awk '{ print $2 }' )
GNM=$(grep genome: $PARAMS | awk '{ print $2 }' )
ANT=$(grep annotation: $PARAMS | awk '{ print $2 }' )
PATH=$(grep path: $PARAMS | awk '{ print $2 }' )

echo "Reading parameters from" $PARAMS
echo "  Working directory created in" $WD
echo "  Number of samples:" $NS
echo "  Downloading/Copying genome from" $GNM
echo "  Downloading/Copying annotation from" $ANT
echo "  The path to the script is" $PATH


SAMPLES=()

I=0

while [ $I -lt $NS ]
do
   SAMPLES[$I]=$(grep sample_$(($I + 1)): $PARAMS | awk '{ print $2 }')
   ((I++))
done

I=0

while [ $I -lt $NS ]
do
   echo sample_$((I+1)) = ${SAMPLES[$I]}
   ((I++))
done


## Generate working directory
mkdir $WD
cd $WD
mkdir genome annotation samples results logs
cd samples

I=1

while [ $I -le $NS ]
do
   mkdir sample_$I
   ((I++))
done

## Downloading reference genome
cd $WD/genome
cp $GNM genome.fa


## gunzip genome.fa.gz
## Lo mismo hay que poner aqui una orden de descomprimir


##Downloading annotatio 
cd $WD/annotation
cp $ANT annotation.gtf

## gunzip annotation.gtf.gz

##Building reference genome index

extract_splice_sites.py annotation.gtf > splice.ss
extract_exons.py annotation.gtf > annot_exons.exon

cd $WD/genome
hisat2-build --ss ../annotation/splice.ss --exon ../annotation/annot_exons.exon genome.fa genome


##Copy samples

cd $WD/samples

I=0
while [ $I -lt $NS ]
do
   cp ${SAMPLES[$I]} sample_$(($I+1))/sample_$(($I+1)).fq.gz
   ((I++))
done

##Empezamos con las tareas que son paralelizables

I=1
while [ $I -le $NS ]
do
   qsub -N sample_$I -o $WD/logs/sample_$I $PATH/rna_seq_sample_processing.sh $SAMPLE_ID $WD $NUM_SAMPLES $PATH
   ((I++))
done
