#!/usr/bin/bash -l
#SBATCH -p short -c 2 --mem 8gb -N 1 -n 1 

IN=/bigdata/stajichlab/shared/projects/ECDRE/Amplicon/data/UF_UCR_ECDRE_Trials/Flowcells/
OUT=input
mkdir -p $OUT
for file in $(ls $IN/*/*_ITS_*.gz)
do
	outname=$(basename $file | perl -p -e 's/_ITS_S\d+_(R[12])_001.fastq.gz/_$1.fastq.gz/')
	ln -s $file $OUT/$outname
done
