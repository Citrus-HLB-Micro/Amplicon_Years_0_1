#!/usr/bin/bash -l
#SBATCH -p short -c 2 --mem 8gb -N 1 -n 1 

IN=/bigdata/stajichlab/shared/projects/ECDRE/Amplicon/data/Pools_1-3/CA_only/16S
CTL=/bigdata/stajichlab/shared/projects/ECDRE/Amplicon/data/Pools_1-3/Controls/16S/
OUT=input
mkdir -p $OUT
for file in $(ls $IN/*_16S_*.gz $CTL/*_16S_*.gz)
do
	outname=$(basename $file | perl -p -e 's/_16S_S\d+_(R[12])_001.fastq.gz/_$1.fastq.gz/')
	ln -s $file $OUT/$outname
done
