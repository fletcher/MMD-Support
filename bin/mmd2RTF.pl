#!/bin/sh

# convert to RTF using textutil - only works on Mac OS X

if [ $# == 0 ]
then
	# No arguments, so use stdin/stdout
	/usr/local/bin/multimarkdown | textutil -convert rtf -stdin -stdout 
else
until [ "$*" = "" ]
do
	# process each argument separately
	file_name=`echo $1|cut -d. -f1 `
	/usr/local/bin/multimarkdown "$1" | textutil -convert rtf -stdin -stdout > "$file_name.rtf"
	shift
done
fi
