#!/usr/bin/perl
use strict;
use warnings;

sub init {
  runTests();

  my $total = calculateTotal();
  print sprintf("%d\n", $total);
}

sub calculateTotal {
  my $total = 0;
  while(<>) {
    $total += calculateFirstAndLastDigitValue($_);
  }
  return $total;
}

sub calculateFirstAndLastDigitValue {
  my $line = shift;

  my $firstDigit = getFirstDigit($line);
  my $lastDigit = getLastDigit($line);

  return ($firstDigit * 10) + $lastDigit;
}

sub getFirstDigit {
  my $string = shift;
  $string =~ /[^\d]*(\d)/;
  return $1;
}

sub getLastDigit {
  my $string = shift;
  $string =~ s/.*(\d)[^\d]*/$1/;
  return $1;
}

sub test {
  my $input = shift;
  my $expected = shift;

  if(calculateFirstAndLastDigitValue($input) != $expected) {
    die sprintf('%d != %d', calculateFirstAndLastDigitValue($input), $expected);
  }
}

sub runTests {
  test('3three16xsxhpnqmzmnine8one', 38);
  test('seven5khtwo891hlb', 51);
  test('sixthreeqpzjpn195', 15);
  test('jrnf3', 33);
}

init();
