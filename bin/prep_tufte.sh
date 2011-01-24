#!/bin/sh

# make changes to overcome limitations/bugs in tufte-handout

until [ "$*" = "" ]
do
	# process each file separately

	# citep avoids putting each reference as a footnote each time it's used
	perl -pi -e 's/\\cite/\\citep/g' "$1"

	# autoref points to the section and not the table\figure
	perl -pi -e 's/\\autoref/\\ref/g' "$1"
	
	shift
done

