#!/usr/bin/perl
use strict;
use warnings;

my %max = (
  red => 12,
  green => 13,
  blue => 14,
);

sub init {
  runTests();

  my $total = calculateTotal();
  print sprintf("%d\n", $total);
}

sub calculateTotal {
  my $total = 0;
  while(<>) {
    chomp;
    $total += getGameNumberIfGameCouldBeWinnerOtherwiseZero($_);
  }
  return $total;
}

sub getGameNumberIfGameCouldBeWinnerOtherwiseZero {
  my $line = shift;
  my $newLine = stripGameNumberFromLine($line);
  my @groups = getGroupsOfCubeColorsPulledFromBag($newLine);

  foreach my $group (@groups) {
    if(groupExceedsLimit($group)) {
      return 0;
    }
  }

  return getGameNumber($line);
}

sub groupExceedsLimit {
  my $group = shift;
  my @cubeColorCounts = split(/, /, $group);
  foreach my $cubeColorCount (@cubeColorCounts) {
    my($count, $color) = split(/ /, $cubeColorCount);
    if($count > $max{$color}) {
      return 1;
    }
  }
  return 0;
}

sub getGroupsOfCubeColorsPulledFromBag {
  my $line = shift;
  return split(/; /, $line);
}

sub getGameNumber {
  my $line = shift;
  $line =~ /^Game (\d+)\: /;
  return $1;
}

sub stripGameNumberFromLine {
  my $line = shift;
  my($game, $rest) = split(/: /, $line, 2);
  return $rest;
}

sub test {
  my $input = shift;
  my $expected = shift;

  if(getGameNumberIfGameCouldBeWinnerOtherwiseZero($input) != $expected) {
    die sprintf('%d != %d', getGameNumberIfGameCouldBeWinnerOtherwiseZero($input), $expected);
  }
}

sub runTests {
  test('Game 1: 8 green; 5 green, 6 blue, 1 red; 2 green, 1 blue, 4 red; 10 green, 1 red, 2 blue; 2 blue, 3 red', 1);
  test('Game 23: 2 blue, 5 green, 13 red; 1 green, 5 blue, 16 red; 6 blue, 9 green, 9 red; 7 green, 3 blue', 0);
  test('Game 16: 3 blue, 2 green, 5 red; 4 green, 3 blue, 4 red; 6 red, 5 blue, 2 green; 3 red, 11 blue; 6 green, 15 blue, 4 red', 0);
}

init();
