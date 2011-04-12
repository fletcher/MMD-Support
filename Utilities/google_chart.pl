#!/usr/bin/env perl


# Import raw MMD

local $/;
$text = <>;

my %chart_defs = ();
my %table_defs = ();

my $line_start = qr{
	[ ]{0,$less_than_tab}
}mx;

my $table_row = qr{
	[^\n]*?\|[^\n]*?\n
}mx;
	
my $first_row = qr{
	$line_start
	\S+.*?\|.*?\n
}mx;

my $table_rows = qr{
	(\n?$table_row)
}mx;

my $table_caption = qr{
	$line_start
	\[.*?\][ \t]*\n
}mx;

my $table_divider = qr{
	$line_start
	[\|\-\+\:\.][ \-\+\|\:\.]* \| [ \-\+\|\:\.]* 
}mx;

my $whole_table = qr{
	($table_caption)?		# Optional caption
	($first_row				# First line must start at beginning
	($table_row)*?)?		# Header Rows
	$table_divider			# Divider/Alignment definitions
	$table_rows+			# Body Rows
	($table_caption)?		# Optional caption
}mx;


# Find whole tables, then break them up and process them into arrays

$text =~ s{
	^($whole_table)			# Whole table in $1
	(\n|\Z)					# End of file or 2 blank lines
}{
	my $table = $1;
	my $orig = $table;
	
	$table =~ s/^\|//mg;
	$table =~ s/\s+\|$//mg;
	$table =~ s/\n[ \t]*\n/\n/sg;
	$table =~ s/[ \t]+\n/\n/g;
	if ($table =~ s/^($table_caption)//m) {
		my @data;
		
		$caption = $1;
		$caption =~ /.*\[([^\]]+)\]/;
		my $label = $1;
		$table =~ s/^$table_divider$//ms;
		$table =~ s/\n\n/\n/g;
		for (split /\n/, $table) {
			push @data, [split /\s*\|\s*/];
		}

		$table_defs{$label} = \@data;

#		print "Table: $label\n";
		for my $row ( @data ) {
#			print "@$row\n";
		}
	}

	"";
#	$orig . "\n";
}egmx;


# Now - find image definitions to google chart API

$text =~ s{
	^([ ]{0,3}\[.*\]:.*chart.apis.google.com.*)
}{
	my $orig = $1;
	my $url = $orig;

#	$orig =~ /src="(.*?)"/;
	my $label = ($orig =~ /src="(.*?)"/i) ? $1 : "";
	my $title = ($orig =~ /title="(.*?)"/i) ? $1 : "";
	$title =~ s/ /+/g;
	my $colors = ($orig =~ /colors="(.*?)"/i) ? $1 : "";

	
	my $data = $table_defs{$label};

	$url =~ s{
		col(\d+)
	}{
		my $col = $1 - 1;
		my $result = "";
		
		for my $i ( 1 .. $#$data) {
			$result .= $$data[$i][$col] . ",";
		}
		$result =~ s/,$//;
#		print "data $result\n";
		$result;
	}esxg;

	$url =~ s{
		colmax(\d+)
	}{
		my $col = $1 - 1;
		my @temp;
		for my $i ( 1 .. $#$data) {
		 	push @temp, $$data[$i][$col];
		}
		
		(sort { $b <=> $a } @temp)[0];
	}esxg;

	$url =~ s{
		colmin(\d+)
	}{
		my $col = $1 - 1;
		my @temp;
		for my $i ( 1 .. $#$data) {
		 	push @temp, $$data[$i][$col];
		}
		
		(sort { $a <=> $b } @temp)[0];
	}esxg;

	$url =~ s{
		(http://chart.apis.google.com[^\s]+)
	}{
		my $result = $1;
		$result .= "&chtt=$title" if ($title ne "");
		$result .= "&chco=$colors" if ($colors ne "");
		
		$result;
	}esgx;
	
	$url;
}egmx;


print $text;