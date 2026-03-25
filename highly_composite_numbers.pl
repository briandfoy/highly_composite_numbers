#!perl

use v5.40;
use Math::Prime::Util qw(divisors);

$|++;

$SIG{'INT'} = sub { exit };
my $winner_so_far;
while(1) {
	state $n = $ARGV[0] // 1;
	state $sequence = 1;

	my @d = divisors($n);
	next unless @d > $winner_so_far;
	$seq++;

	$winner_so_far = @d;
	say "$seq $n ($winner_so_far): @d";
	}

# 897612484786617600
# 1102701600
