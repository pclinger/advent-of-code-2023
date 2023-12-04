#!/usr/bin/perl
use strict;
use warnings;

sub init {
  my $total = 0;
  my @lines = <>;
  chomp(@lines);
  my $totalLines = ~~@lines;
  my @copies = (1) x $totalLines;
  my $totalCards = 0;
  foreach my $index (0 .. $totalLines-1) {
    my $result = getResult($lines[$index]);

    my $thisCardNumCopies = $copies[$index];
    $totalCards += $thisCardNumCopies;

    foreach my $num (1 .. $result) {
      my $newIndex = $index + $num;
      if($newIndex >= $totalLines) {
        last;
      }
      $copies[$index+$num] += $thisCardNumCopies;
    }
  }
  print sprintf("%d\n", $totalCards);
}

sub getResult {
  my $line = shift;
  my ($winners, $numbers) = split(/\|/, $line);
  $winners =~ s/.*?://;

  my @winners = parseIntsFromLine($winners);
  my @numbers = parseIntsFromLine($numbers);
  my %winners = map { $_ => 1 } @winners;

  my $total = 0;
  foreach my $number (@numbers) {
    if(defined $winners{$number}) {
      $total++;
    }
  }
  return $total;
}

sub parseIntsFromLine {
  my $line = shift;
  my @ints = $line =~ /(-?\d+)/g;
  return @ints;
}

init();
