#!/usr/bin/bash -l

#SBATCH --time=12:00:00   # walltime
#SBATCH -N 1 -n 1 -c 48
#SBATCH --mem=48gb # memory per CPU core
#SBATCH --out logs/ASV_NCBI_vsearch.%A.log

CPU=$SLURM_CPUS_ON_NODE # set the CPUS dynamicall for the job
if [ -z $CPU ]; then # unless this is not really a slurm job
 CPU=2 # set the number of CPUs to 2
fi

module load amptk
module load usearch

BASE=ECDRE_Y0_1_OTU_CA_only.20240501

#Change this to match your data folder name
INPUT=input

#Pre-processing steps will use `amptk illumina` command for demultiplexed PE reads
if [ ! -f $BASE.demux.fq.gz ]; then
	amptk illumina -i $INPUT --merge_method vsearch -f ITS1-F -r ITS2 --require_primer off -o $BASE --usearch usearch9  --rescue_forward on --primer_mismatch 2 -l 250 --cpus $CPU
fi

if [ ! -f $BASE.ASV_table.txt ];  then
 amptk cluster -i $BASE.demux.fq.gz -o $BASE --uchime_ref ITS --usearch usearch9 -e 0.9 --cpus $CPU
fi

if [ ! -f $BASE.taxonomy.txt ]; then
 amptk taxonomy -f $BASE.otus.fa -i $BASE.otu_table.txt -d ITS
fi
