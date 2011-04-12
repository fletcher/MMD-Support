#!/usr/bin/env perl
#
# dumbpants.pl -- reverse the effects of SmartyPants
#
#	Useful for converting XHTML back into MMD
#


local $/;

my $text = <>;

$text =~ s/&#822[01];/"/g;		# Undo curly double quotes

$text =~ s/&#821[67];/'/g;		# Undo curly single quotes



print $text;