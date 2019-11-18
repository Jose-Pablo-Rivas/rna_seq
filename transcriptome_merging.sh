## Autor: Jose Martin
## Contacto: marmorper20@us.es

#! /bin/bash


## Parameters loading
WD=$1

## Transcriptome merging
cd $WD/results

## Merging sample transcriptomes
stringtie --merge -G $WD/annotation/annotation.gtf -o stringtie_merged.gtf $WD/results/merge_list.txt

## Comparing our assembly with the reference
gffcompare -r $WD/annotation/annotation.gtf -G -o comparison stringtie_merged.gtf

mv ../../sample_* $WD/results

mv ../../transcriptome_merging.* $WD/results
