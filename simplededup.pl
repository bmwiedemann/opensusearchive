#!/usr/bin/perl -w
use strict;
use Digest;
# finds duplicates that have the similar names
# and replaces them with hardlinks
# usage:
# find -type f | rev | sort | rev | $0

our @dups=();
sub flush()
{
        if($#dups > 0) {
		print STDERR "found dups: @dups\n";
		my $ref = pop(@dups); # take from end of list to get newest mtime
		for my $dup (@dups) {
		    print "ln -f $ref $dup\n"
		}
	}
        @dups=();
}

our $prevhash="";
while(<>) {
    chomp;
    my $filename = $_;
    open(my $fd, "<", $filename) or die $!;
    my $sha = Digest->new("SHA-256");
    $sha->addfile($fd);
    my $hash = $sha->digest();
    #print "hash:$hash file:$filename\n";
    if($hash ne $prevhash) {
        flush();
    }
    push(@dups, $filename);
    $prevhash = $hash;
}
flush();
