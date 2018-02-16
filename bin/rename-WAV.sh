#!/bin/bash
for f in $(find . -type f -name '*.WAV' )
do
   a="${f##*/}"    
   b="${a,,}"
   new_name="$(date -r $f +'%Y-%m-%d_%H-%M-%S')__${b:7}"
   echo "$f -> ${f%/*}/${new_name}" 
   mv "$f" "${f%/*}/${new_name}"
#   `echo "mv $f ${f%/*}/${name}" `
#   `echo "mv $f ${f%/*}/$(date -r $f +'%Y-%m-%d_%H-%M-%S')__${b:7}" `
done

