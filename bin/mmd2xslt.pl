#!/bin/sh

# convert to RTF using textutil - only works on Mac OS X

if [ $# == 0 ]
then
	# No arguments, so use stdin/stdout
	/usr/local/bin/multimarkdown | xsltproc -nonet -novalid /Users/fletcher/Active\ Projects/peg-multimarkdown/MMD/XSLT/memoir.xslt - 
else
until [ "$*" = "" ]
do
	# process each argument separately
	file_name=`echo $1|cut -d. -f1 `
	/usr/local/bin/multimarkdown "$1" | xsltproc -nonet -novalid /Users/fletcher/Active\ Projects/peg-multimarkdown/MMD/XSLT/memoir.xslt -  > "$file_name.tex"
	shift
done
fi


