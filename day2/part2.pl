#!/usr/bin/perl
use strict;
use warnings;

my @colors = ('red', 'green', 'blue');

sub init {
  runTests();

  my $total = calculateTotal();
  print sprintf("%d\n", $total);
}

sub calculateTotal {
  my $total = 0;
  while(<>) {
    chomp;
    $total += calculateSetOfCubesPower($_);
  }
  return $total;
}

sub calculateSetOfCubesPower {
  my $line = shift;
  my $newLine = stripGameNumberFromLine($line);
  my @groups = getGroupsOfCubeColorsPulledFromBag($newLine);

  my %maxOfEachColor = (
    red => 0,
    green => 0,
    blue => 0,
  );
  foreach my $group (@groups) {
    my $cubesByColor = getCubesByColor($group);
    
    foreach my $color (@colors) {
      $maxOfEachColor{$color} = $cubesByColor->{$color} if $cubesByColor->{$color} > $maxOfEachColor{$color};
    }
  }

  return $maxOfEachColor{red} * $maxOfEachColor{green} * $maxOfEachColor{blue};
}

sub getCubesByColor {
  my $cubesByColor = {
    red => 0,
    green => 0,
    blue => 0,
  };
  my $group = shift;
  my @cubeColorCounts = split(/, /, $group);
  foreach my $cubeColorCount (@cubeColorCounts) {
    my($count, $color) = split(/ /, $cubeColorCount);
    $cubesByColor->{$color} = $count;
  }
  return $cubesByColor;
}

sub getGroupsOfCubeColorsPulledFromBag {
  my $line = shift;
  return split(/; /, $line);
}

sub stripGameNumberFromLine {
  my $line = shift;
  my($game, $rest) = split(/: /, $line, 2);
  return $rest;
}

sub test {
  my $input = shift;
  my $expected = shift;

  if(calculateSetOfCubesPower($input) != $expected) {
    die sprintf('%d != %d', getGameNumberIfGameCouldBeWinnerOtherwiseZero($input), $expected);
  }
}

sub runTests {
  test('Game 1: 8 green; 5 green, 6 blue, 1 red; 2 green, 1 blue, 4 red; 10 green, 1 red, 2 blue; 2 blue, 3 red', 240);
  test('Game 23: 2 blue, 5 green, 13 red; 1 green, 5 blue, 16 red; 6 blue, 9 green, 9 red; 7 green, 3 blue', 864);
  test('Game 16: 3 blue, 2 green, 5 red; 4 green, 3 blue, 4 red; 6 red, 5 blue, 2 green; 3 red, 11 blue; 6 green, 15 blue, 4 red', 540);
}

init();
