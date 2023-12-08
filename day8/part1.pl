#!/usr/bin/perl
use strict;
use warnings;

sub init {
  my @input = <>;
  chomp(@input);

  my @directions = split(//, shift(@input));
  shift(@input);
  my $map = {};
  foreach my $line (@input) {
    $line =~ /(\w+)\s=\s\((\w+),\s(\w+)\)/;
    $map->{$1} = [$2, $3]; # left, right
  }
  my $count = 0;
  my $current = $map->{AAA};
  my $location = 'AAA';
  while(1) {
    foreach my $direction (@directions) {
      $count++;
      if($direction eq 'L') {
        $location = $current->[0];
        $current = $map->{$location};
      } else {
        $location = $current->[1];
        $current = $map->{$location};
      }
    }
    if($location eq 'ZZZ') {
      last;
    }
  }
  print "$count\n";
}

sub parseIntsFromLine {
  my $line = shift;
  my @ints = $line =~ /(-?\d+)/g;
  return @ints;
}

init();
