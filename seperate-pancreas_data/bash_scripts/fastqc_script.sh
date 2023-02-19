#!/bin/bash

# the script has to be in the data directory containing the samples directories
# get directory names that start with NGS
all_dirs=$(sudo find NGS*/ -maxdepth 0 -type d)

# iterate over directories
for dir in $all_dirs; do
    echo "entering directory $dir"
    # move to NGS folder
    cd "$dir"
    # get directory name for new merge directory containing merged files
    # dir_name=$(echo $dir| tr '/' ' '|sed 's/ /_merged/')
    # get R1 and R2 identifiers
    array=$(sudo find ./ -type f -name '*.fastq.gz' | awk -F_ '{print $4}'|sort|uniq)
    mkdir quality_control/
    # iterate over identifiers:
    for uniq_identifier in $array; do
	echo "iterating over $uniq_identifier"
	# get new file name without L001
	file_name=$(echo *$uniq_identifier*.gz)
	echo $file_name
	# merge both files into one, provide new directory name and filename
	fastqc -o quality_control/ -t 8 -f $file_name
    done
    # go to the DATA folder
    echo 'Moving back to data...'
    cd ..
done

echo 'DONE.'
