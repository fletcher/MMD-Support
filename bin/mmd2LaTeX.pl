#!/bin/sh
#
# mmd2tex --- MultiMarkdown convenience script
#	<http://fletcherpenney.net/multimarkdown/>
#	Fletcher T. Penney
#
# Pass arguments on to the binary to convert text to LaTeX
#

if [ $# == 0 ]
then
	multimarkdown -t latex
else
until [ "$*" = "" ]
do
	multimarkdown -b -t latex "$1"
	shift
done
fi
