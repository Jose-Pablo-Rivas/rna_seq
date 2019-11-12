## Autor: Jose Martin
## Contacto: marmorper20@us.es



#! /bin/bash

## DESPUES DE HACER ESTO CON TODAS LAS MUESTRAS:

## Transcriptome merging

cd ../../results

## Merging sample transcriptomes

stringtie --merge -G ../annotation/annotation.gtf -o stringtie_merged.gtf merge_list.txt

## Comparing our assembly with the reference

gffcompare -r ../annotation/annotation.gtf -G -o comparison stringtie_merged.gtf

