#!/usr/bin/perl -w
use strict;
use Digest;
# finds duplicates that have the similar names
# and replaces them with hardlinks
# usage:
# find -type f | rev | sort | rev | $0

our @dups=();
our @prevstat;
sub flush()
{
	#print STDERR "$prevstat[3] ".scalar(@dups)."\n";
        if($#dups > 0 && $prevstat[3] != scalar(@dups)) {
		print STDERR "found dups: @dups\n";
		my $ref = pop(@dups); # take from end of list to get newest mtime
		for my $dup (@dups) {
		    print "cmp $ref $dup && ln -f $ref $dup\n"
		}
	}
        @dups=();
}

while(<>) {
    chomp;
    my $filename = $_;
    my @stat = stat($_);
    if(defined($prevstat[7]) && $stat[7] != $prevstat[7]) {
        flush();
    }
    push(@dups, $filename);
    @prevstat = @stat;
}
flush();
