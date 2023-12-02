#!/usr/bin/perl
use strict;
use warnings;
use constant {
  SEARCH_FOR_FIRST_DIGIT => 1,
  SEARCH_FOR_LAST_DIGIT => 0,
};

my %numbersAsStrings = (
  one => 1,
  two => 2,
  three => 3,
  four => 4,
  five => 5,
  six => 6,
  seven => 7,
  eight => 8,
  nine => 9,
);
my @numbersAsStrings = keys %numbersAsStrings;
my @numbers = (1 .. 9);

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

  my $firstDigit = getDigit($line, SEARCH_FOR_FIRST_DIGIT);
  my $lastDigit = getDigit($line, SEARCH_FOR_LAST_DIGIT);

  return ($firstDigit * 10) + $lastDigit;
}

sub getDigit {
  my $string = shift;
  my $searchForFirstDigit = shift;

  my ($number, $numberPosition) = getNumberAndPosition($string, $searchForFirstDigit, @numbers);
  my ($stringNumber, $stringNumberPosition) = getNumberAndPosition($string, $searchForFirstDigit, @numbersAsStrings);

  if($searchForFirstDigit) {
    return $stringNumberPosition == -1 || ($numberPosition != -1 && $numberPosition < $stringNumberPosition)
      ? $number
      : $numbersAsStrings{$stringNumber} // 0;
  }

  return $stringNumberPosition == -1 || ($numberPosition != -1 && $numberPosition > $stringNumberPosition)
    ? $number
    : $numbersAsStrings{$stringNumber} // 0;

}

sub getNumberAndPosition {
  my $string = shift;
  my $searchForFirstDigit = shift;
  my @numbers = @_;

  my $bestPosition = -1;
  my $bestNumber = 0;
  foreach my $number (@numbers) {
    my $position = getIndex($string, $number, $searchForFirstDigit);
    my $foundPosition = $position > -1;
    my $bestPositionIsNotSet = $bestPosition == -1;
    my $foundPositionIsBetter = ($searchForFirstDigit && $position < $bestPosition) || (!$searchForFirstDigit && $position > $bestPosition);

    if($foundPosition && ($bestPositionIsNotSet || $foundPositionIsBetter)) {
      $bestPosition = $position;
      $bestNumber = $number;
    }
  }
  return ($bestNumber, $bestPosition);
}

sub getIndex {
  my $string = shift;
  my $number = shift;
  my $searchForFirstDigit = shift;

  if($searchForFirstDigit) {
    return index($string, $number);
  }
  # Reverse lookup for the last number
  return rindex($string, $number);
}

sub testCalculateFirstAndLastDigitValue {
  my $input = shift;
  my $expected = shift;

  if(calculateFirstAndLastDigitValue($input) != $expected) {
    die sprintf('%d != %d', calculateFirstAndLastDigitValue($input), $expected);
  }
}

sub testGetIndex {
  my $string = shift;
  my $number = shift;
  my $searchForFirstDigit = shift;
  my $expected = shift;

  if(getIndex($string, $number, $searchForFirstDigit) != $expected) {
    die sprintf('%d != %d', getIndex($string, $number, $searchForFirstDigit), $expected);
  }
}

sub testGetNumberAndPosition {
  my $params = shift;
  my $string = $params->{string};
  my $searchForFirstDigit = $params->{searchForFirstDigit};
  my @numbers = @{$params->{numbers}};
  my $expectedNumber = $params->{expectedNumber};
  my $expectedPosition = $params->{expectedPosition};

  my ($number, $position) = getNumberAndPosition($string, $searchForFirstDigit, @numbers);

  if($number ne $expectedNumber || $position != $expectedPosition) {
    die sprintf('%s != %s or %d != %d', $number, $expectedNumber, $position, $expectedPosition);
  }
}

sub testGetDigit {
  my $string = shift;
  my $searchForFirstDigit = shift;
  my $expected = shift;

  if(getDigit($string, $searchForFirstDigit) != $expected) {
    die sprintf('%d != %d', getDigit($string, $searchForFirstDigit), $expected);
  }
}

sub runTests {
  testGetIndex('3three16xsxhpnqmzmnine8one', 3, SEARCH_FOR_FIRST_DIGIT, 0);
  testGetIndex('3three16xsxhpnqmzmnine8one', 'one', SEARCH_FOR_LAST_DIGIT, 23);

  testGetNumberAndPosition({
    string => '3three16xsxhpnqmzmnine8one',
    searchForFirstDigit => SEARCH_FOR_FIRST_DIGIT,
    numbers => \@numbers,
    expectedNumber => 3,
    expectedPosition => 0,
  });
  testGetNumberAndPosition({
    string => '3three16xsxhpnqmzmnine8one',
    searchForFirstDigit => SEARCH_FOR_LAST_DIGIT,
    numbers => \@numbersAsStrings,
    expectedNumber => 'one',
    expectedPosition => 23,
  });

  testGetDigit('3three16xsxhpnqmzmnine8one', SEARCH_FOR_FIRST_DIGIT, 3);
  testGetDigit('3three16xsxhpnqmzmnine8one', SEARCH_FOR_LAST_DIGIT, 1);

  testCalculateFirstAndLastDigitValue('3three16xsxhpnqmzmnine8one', 31);
  testCalculateFirstAndLastDigitValue('seven5khtwo891hlb', 71);
  testCalculateFirstAndLastDigitValue('sixthreeqpzjpn195', 65);
  testCalculateFirstAndLastDigitValue('jrnf3', 33);
  testCalculateFirstAndLastDigitValue('eightwo', 82);

}

init();
