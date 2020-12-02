#!/bin/bash

tools=/seq/schatz/malonge/bamdev1_src
SCRIPT=$tools/T2T-Polish/marker_assisted
echo $SCRIPT > SCRIPT

if [[ "$#" -lt 5 ]]; then
	echo "Usage: ./submit.sh in.bam target asm.fasta marker.meryl len_filt"
	echo -e "\tin.bam: alignment file. .bam or .cram"
	echo -e "\ttarget: chromosome or sequence id to extract"
	echo -e "\tasm.fasta: target.fasta or multi-fasta asm.fasta which contains the target sequence"
	echo -e "\tmarker.meryl: marker meryl db (ex. single-copy kmer db)"
	echo -e "\tlen_filt: length filter, in kb (INTEGER). ex. 1 for 1kb"
	exit 0
fi

bam=$1
target=$2
fa=$3
meryldb=$4
len_filt=$5
echo $len_filt > LEN_FILT

cpus=24
mem=4g
name=$target.init
script=$SCRIPT/init.sh
args="$bam $target $fa $meryldb"

mkdir -p logs
log=logs/$name.%A.log

echo "\
qsub -terse -N $name -l m_mem_free=$mem -S /bin/bash -pe threads $cpus -cwd -e=$log -o=$log $script $args"
qsub -terse -N $name -l m_mem_free=$mem -S /bin/bash -pe threads $cpus -cwd -e=$log -o=$log $script $args

