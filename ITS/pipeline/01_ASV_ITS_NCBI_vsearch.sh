#!/usr/bin/bash -l

#SBATCH --time=12:00:00   # walltime
#SBATCH -N 1 -n 1 -c 48
#SBATCH --mem=48gb # memory per CPU core
#SBATCH --out logs/ASV_NCBI_vsearch.%A.log

module load amptk
module load usearch

BASE=ECDRE_Y0_1_NCBI

#Change this to match your data folder name
INPUT=input

#Pre-processing steps will use `amptk illumina` command for demultiplexed PE reads
if [ ! -f $BASE.demux.fq.gz ]; then
	amptk illumina -i $INPUT --merge_method vsearch -f ITS1-F -r ITS2 --require_primer off -o $BASE --usearch usearch9  --rescue_forward on --primer_mismatch 2 -l 250
fi

if [ ! -f $BASE.ASV_table.txt ];  then
 amptk dada2 -i $BASE.demux.fq.gz -o $BASE --uchime_ref ITS --usearch usearch9 -e 0.9
fi

if [ ! -f $BASE.taxonomy.txt ]; then
 amptk taxonomy -f $BASE.dada2.ASV.fa -i $BASE.ASV_table.txt -d FungiITSrefseq
fi
