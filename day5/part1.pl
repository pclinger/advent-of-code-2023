#!/usr/bin/perl
use strict;
use warnings;

our $order = {};
sub init {
  my $total = 0;
  my @lines = <>;
  chomp(@lines);
  my @seeds = parseIntsFromLine(shift(@lines));

  my $maps = getMaps(@lines);

  my $lowest = undef;
  seed: foreach my $value (@seeds) {
    my $current = 'soil';
    my $seed = $value;
    loop: while(1) {
      foreach my $map (@{$maps->{$current}}) {
        my($destinationRange, $sourceRange, $range) = @{$map};
        if($value >= $sourceRange && $value < $sourceRange + $range) {
          # Calculate how far forward we need to go
          my $forward = $value - $sourceRange;
          $value = $destinationRange + $forward;
          if($current eq 'location') {
            if(!defined $lowest) {
              $lowest = $value;
            } elsif($value < $lowest) {
              $lowest = $value ;
            }
            next seed;
          }
          $current = $order->{$current};
          next loop;
        }
      }
      next seed;
    }
  }

  print sprintf("%d\n", $lowest);
}

sub getMaps {
  my $maps = {};
  my @lines = @_;
  my $type = undef;
  foreach my $line (@lines) {
    next if($line eq '');
    if($line =~ /-to-/) {
      $line =~ s/(.*)-to-(.+) map:/$2/;
      $order->{$1} = $2;
      $type = $line;
      $maps->{$type} = [];
      next;
    } elsif($line =~ /^\d/) {
      my @ints = parseIntsFromLine($line);
      push(@{$maps->{$type}}, \@ints);
    }
  }
  return $maps;
}

sub parseIntsFromLine {
  my $line = shift;
  my @ints = $line =~ /(-?\d+)/g;
  return @ints;
}

init();
