#!/usr/bin/perl -w
use strict;

use Getopt::Long;

my @board;
my ($from_location, $to_location);

while (<DATA>) {
	push @board, $_;
}
print_board(\@board);

GetOptions(
	"c|coordinates=s{2}" => \my @coordinates,
	) or die "Usage: $0\n";
	
while ((scalar @coordinates) >= 2) {
	$from_location = shift @coordinates;
	next if ($from_location !~ /^\d-\d$/);
	$to_location = shift @coordinates;
	next if ($to_location !~ /^\d-\d$/);
	move(\@board, $from_location, $to_location);
	sleep 1;
	print_board(\@board);
}

while (1) {
	print "Enter the coordinates of the piece to move (format example: 0-3) or (q)uit.\n> ";
	$from_location = <STDIN>;
	chomp $from_location;
	$from_location = lc($from_location);
	last if $from_location eq 'q';
	if ($from_location !~ /^\d-\d$/) {
		print "Not correct format.\n";
		next;
	}
	print "Enter the coordinates to place the piece (format example: 0-3) or (q)uit\n> ";
	$to_location = <STDIN>;
	chomp $to_location;
	if ($to_location !~ /^\d-\d$/) {
		print "Not correct format.\n";
		next;
	}
	$to_location = lc($to_location);
	last if $to_location eq 'q';
	
	move(\@board, $from_location, $to_location);
	print_board(\@board);
}


sub move {
	my ($bref, $from, $to) = @_;
	my @from_location = split /-/, $from;
	my @to_location = split /-/, $to;
	my @from_row = split / /, $bref->[$from_location[0]];
	my $from_piece = $from_row[$from_location[1]];
	$from_row[$from_location[1]] = '--';
	$bref->[$from_location[0]] = join " ", @from_row;
	
	my @to_row = split / /, $bref->[$to_location[0]];
	$to_row[$to_location[1]] = $from_piece;	
	$bref->[$to_location[0]] = join " ", @to_row;
}


sub print_board {
	my $board_ref = shift;
	print "\n     0  1  2  3  4  5  6  7\n";
	print "  ", "-" x 27, "\n";
	my $row_counter = 0;
	for my $row (@$board_ref) {
		for my $column ($row) {
			chomp $column;
			print "$row_counter | $column ";
			$row_counter++;
		}
	print "|\n";
	}
	print "  ", "-" x 27, "\n";
}

__END__
Br Bk Bb BQ BK Bb Bk Br
Bp Bp Bp Bp Bp Bp Bp Bp
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --
Wp Wp Wp Wp Wp Wp Wp Wp
Wr Wk Wb WQ WK Wb Wk Wr