#!/usr/bin/perl
use strict;
use warnings;

# This was a major rush job to try to get onto the leaderboard

sub init {
  my $total = calculateTotal();
  print sprintf("%d\n", $total);
}

sub calculateTotal {
  my $total = 0;
  my @grid = ();
  while(<>) {
    chomp;
    my @line = split(//, $_);
    push(@grid, \@line);
  }

  my %found = ();

  my @groupings = ();
  my $foundNumber = 0;
  my $groupNumber = 0;
  my %groupNumbers = ();
  for(my $i=0; $i<scalar(@grid); $i++) {
    push(@groupings, [(-1) x scalar(@{$grid[$i]})]);
    for(my $j=0; $j<scalar(@{$grid[$i]}); $j++) {
      my $char = $grid[$i]->[$j];
      if($char eq '.') {
        $foundNumber = 0;
        next;
      }
      if($char =~ /\d/) {
        if(!$foundNumber) {
          $groupNumber++;
          $foundNumber = 1;
          $groupNumbers{$groupNumber} = 0;
        }
        $groupings[$i]->[$j] = $groupNumber;
        $groupNumbers{$groupNumber} *= 10;
        $groupNumbers{$groupNumber} += $char;
        next;
      }
      $foundNumber = 0;
    }
  }


  for(my $i=0; $i<scalar(@grid); $i++) {
    for(my $j=0; $j<scalar(@{$grid[$i]}); $j++) {
      my $char = $grid[$i]->[$j];
      next if($char eq '.');
      next if($char =~ /\d/);
      my @positions = ([$i, $j+1], [$i, $j-1], [$i-1, $j], [$i-1, $j-1], [$i-1, $j+1], [$i+1, $j], [$i+1, $j-1], [$i+1, $j+1]);
      foreach my $pos (@positions) {
        my($row, $col) = @$pos;
        next if(!($row >= 0 && $row < scalar(@grid) && $col >= 0 && $col < scalar(@{$grid[$row]})));
        next if($groupings[$row]->[$col] == -1);
        
        next if($found{$groupings[$row]->[$col]});
        $found{$groupings[$row]->[$col]} = 1;
        $total += $groupNumbers{$groupings[$row]->[$col]};
      }
    }
  }
  return $total;
}

init();
