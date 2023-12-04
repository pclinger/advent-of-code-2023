#!/usr/bin/perl
use strict;
use warnings;

sub init {
  my $total = 0;
  while(<>) {
    $total += getResult($_);
  }
  print sprintf("%d\n", $total);
}

sub getResult {
  my $line = shift;
  my ($winners, $numbers) = split(/\|/, $line);
  $winners =~ s/.*?://;
  my @winners = parseIntsFromLine($winners);
  my @numbers = parseIntsFromLine($numbers);
  my %winners = map { $_ => 1 } @winners;

  my $total = undef;
  foreach my $number (@numbers) {
    if(defined $winners{$number}) {
      if(!defined $total) {
        $total = 1;
      } else {
        $total *= 2;
      }
    }
  }
  return $total // 0;
}

sub parseIntsFromLine {
  my $line = shift;
  my @ints = $line =~ /(-?\d+)/g;
  return @ints;
}

init();
