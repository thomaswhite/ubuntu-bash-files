#! /usr/bin/env bash

#cd /var/cache/apt/archives/
for pkg in $(ls *.deb | cut -d _ -f 1 | sort -u); do
    if [ $(ls $pkg\_* | wc -l) -gt 1 ]; then
        files=$(ls -vr $pkg\_*)
        rmfiles=$(echo $files | cut -d " " -f 2-)
        rm -v $rmfiles
    fi
done
