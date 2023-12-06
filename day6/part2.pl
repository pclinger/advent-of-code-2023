#!/usr/bin/perl
use strict;
use warnings;

sub init {
  my %timeToDistance = (
    53897698 => 313109012141201,
  );

  my @waysToWin = ();
  foreach my $key (keys %timeToDistance) {
    my $waysToWin = 0;
    foreach my $seconds (1 .. $key) {
      my $speed = $seconds;
      my $distance = $speed * ($key - $seconds);
      if($distance > $timeToDistance{$key}) {
        $waysToWin++;
      }
    }
    push(@waysToWin, $waysToWin);
  }

  my $result = 1;
  $result *= $_ foreach (@waysToWin);
  print "$result\n";
}

init();
