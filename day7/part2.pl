#!/usr/bin/perl
use strict;
use warnings;

my @scores = ();
my %cardRank = (
  A => 14,
  K => 13,
  Q => 12,
  J => 11,
  T => 10,
  9 => 9,
  8 => 8,
  7 => 7,
  6 => 6,
  5 => 5,
  4 => 4,
  3 => 3,
  2 => 2,
  J => 0,
);

my %scoreToHand = (
  7 => 'Five of a kind',
  6 => 'Four of a kind',
  5 => 'Full house',
  4 => 'Three of a kind',
  3 => 'Two pair',
  2 => 'One pair',
  1 => 'High card',
);

sub init {
  my @hands = <>;

  my @results = ();
  foreach my $hand (@hands) {
    my($cards, $bid) = split(/\s+/, $hand);
    push(@results, {
      score => getScore($cards),
      cards => $cards,
      bid => $bid,
    });
  }

  my @sorted = sort byCardsSort @results;

  my $count = 0;
  my $total = 0;
  foreach my $sort (@sorted) {
    $count++;
    $total += $sort->{bid} * $count;
  }
  print sprintf("%d\n", $total);
}

sub byCardsSort {
  if($a->{score} == $b->{score}) {
    return equalRankTiebreaker($a, $b);
  }
  return $a->{score} <=> $b->{score};
}

sub equalRankTiebreaker {
  my $a = shift;
  my $b = shift;
  for(0 .. 4) {
    my $aRank = $cardRank{substr($a->{cards}, $_, 1)};
    my $bRank = $cardRank{substr($b->{cards}, $_, 1)};
    if($aRank < $bRank) {
      return -1;
    } elsif($aRank > $bRank) {
      return 1;
    }
  }
  return 0;
}

sub getScore {
  my $cards = shift;
  my %cards = ();
  my $jokers = 0;
  foreach my $card (split(//, $cards)) {
    if($card eq 'J') {
      $jokers++;
    } else {
      $cards{$card}++;
    }
  }
  my $hasFiveOfAKind = 0;
  my $hasFourOfAKind = 0;
  my $hasThreeOfAKind = 0;
  my $hasFullHouse = 0;
  my $pairs = 0;
  foreach my $card (keys %cards) {
    if($cards{$card} == 5) {
      $hasFiveOfAKind = 1;
    } elsif($cards{$card} == 4) {
      $hasFourOfAKind = 1;
    } elsif($cards{$card} == 3) {
      $hasThreeOfAKind = 1;
    } elsif ($cards{$card} == 2) {
      $pairs++;
    }
  }
  
  if($jokers) {
    if($jokers == 5) {
      $hasFiveOfAKind = 1;
    } elsif($hasFourOfAKind) {
      $hasFiveOfAKind = 1;
    } elsif($hasThreeOfAKind) {
      if($jokers == 2) {
        $hasFiveOfAKind = 1;
      } else {
        $hasFourOfAKind = 1;
      }
    } elsif($pairs == 0) {
      if($jokers == 4) {
        $hasFiveOfAKind = 1;
      } elsif($jokers == 3) {
        $hasFourOfAKind = 1;
      } elsif($jokers == 2) {
        $hasThreeOfAKind = 1;
      } else {
        $pairs++;
      }
    } elsif($pairs == 1) {
      if($jokers == 3) {
        $hasFiveOfAKind = 1;
      } elsif($jokers == 2) {
        $hasFourOfAKind = 1;
      } else {
        $hasThreeOfAKind = 1;
        $pairs--;
      }
    } elsif($pairs == 2) {
      # full house
      $hasThreeOfAKind = 1;
      $pairs--;
    }
  }

  # 7: Five of a kind, where all five cards have the same label: AAAAA
  # 6: Four of a kind, where four cards have the same label and one card has a different label: AA8AA
  # 5: Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
  # 4: Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
  # 3: Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
  # 2: One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
  # 1: High card, where all cards' labels are distinct: 23456

  if($hasFiveOfAKind) {
    return 7;
  }
  if($hasFourOfAKind) {
    return 6;
  }
  if($hasThreeOfAKind && $pairs) {
    return 5;
  }
  if($hasThreeOfAKind) {
    return 4;
  }
  if($pairs == 2) {
    return 3;
  }
  if($pairs) {
    return 2;
  }
  return 1;
}

init();
