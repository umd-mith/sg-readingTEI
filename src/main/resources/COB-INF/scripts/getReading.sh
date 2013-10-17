#!/bin/bash
FILES=/home/rviglian/Projects/MITH_XSLT/ms-pages/*
for f in $FILES
do
  filename=$(basename "$f")
  extension="${filename##*.}"
  filename="${filename%.*}"
  curl http://sga.mith.org:8080/readingTEI/"$filename" -H 'Content-Type:text/html' > html/"$filename".html
  curl http://sga.mith.org:8080/readingTEI/"$filename" -H 'Content-Type:text/xml' > xml/"$filename".xml
done