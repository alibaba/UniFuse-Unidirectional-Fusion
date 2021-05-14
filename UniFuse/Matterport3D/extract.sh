#!/bin/bash

clear

var="Extracting"
echo $var


for entry in `ls -d */`; do
	echo $entry
	cd $entry
    for file in `ls -d *.zip`; do
    	echo extracting $file
    	unzip $file
    done
    cd $entry
    mv * ../
    cd ..
    rm -r $entry
    cd ..
done