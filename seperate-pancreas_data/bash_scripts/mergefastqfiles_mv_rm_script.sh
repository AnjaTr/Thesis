#!/bin/bash

# get directory names that start with NGS
all_dirs=$(sudo find NGS*/ -maxdepth 0 -type d)

# iterate over directories
for dir in $all_dirs; do
    echo "entering directory $dir"
    # move to NGS folder
    cd "$dir"
    # get directory name for new merge directory containing merged files
    dir_name=$(echo $dir| tr '/' ' '|sed 's/ /_merged/')
    # get R1 and R2 identifiers
    array=$(sudo find ./ -type f -name '*.fastq.gz' | awk -F_ '{print $5}'|sort|uniq)
    mkdir ../$dir_name/
    # iterate over identifiers:
    for uniq_identifier in $array; do
	echo "iterating over $uniq_identifier"
	# get new file name without L001
	file_name=$(echo *L001_$uniq_identifier*.gz| sed 's/_L001//')
	# merge both files into one, provide new directory name and filename
        cat *$uniq_identifier*.gz > ../$dir_name/$file_name 
    done
    # go to the DATA folder
    echo 'Moving back to data...'
    cd ..
    mv $dir*.metadata $dir_name/
    echo 'Removing old directory.'
    rm -r $dir
    echo 'DONE.'
done
