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

  my @nodeNames = grep { substr($_,2,1) eq 'A' } keys %$map;

  my @results = ();
  foreach my $nodeName (@nodeNames) {
    push(@results, solve($map->{$nodeName}, $nodeName, \@directions, $map));
  }
  my $leastCommonMultiple = leastCommonMultipleOfArray(\@results);

  print "$leastCommonMultiple\n";
  
  sub maxFromArray {
    my $array = shift;
    my $max = $array->[0];
    for(my $i=1; $i<@$array; $i++) {
      if($array->[$i] > $max) {
        $max = $array->[$i];
      }
    }
    return $max;
  }

  sub leastCommonMultipleOfArray {
    my $array = shift;
    my $lcm = $array->[0];
    for(my $i=1; $i<@$array; $i++) {
      $lcm = leastCommonMultiple($lcm, $array->[$i]);
    }
    return $lcm;
  }

  sub leastCommonMultiple {
    my $a = shift;
    my $b = shift;
    my $gcd = greatestCommonDivisor($a, $b);
    return ($a * $b) / $gcd;
  }

  sub greatestCommonDivisor {
    my $a = shift;
    my $b = shift;
    while($b != 0) {
      my $t = $b;
      $b = $a % $b;
      $a = $t;
    }
    return $a;
  }

  sub solve {
    my $count = 0;
    my $current = shift;
    my $location = shift;
    my @directions = @{shift()};
    my $map = shift;
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
      if(substr($location, 2, 1) eq 'Z') {
        last;
      }
    }
    return $count;
  }
}

init();
