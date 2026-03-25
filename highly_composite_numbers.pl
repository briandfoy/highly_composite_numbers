#!perl
use v5.40;
use Math::Prime::Util qw(divisors);

$|++;

my( $file ) = @ARGV;
my( $seq, $n );
my $winner_so_far;

if( open my $fh, '<', $file ) {
	my $last;
	$last = $_ while(<$fh>);

	$last = trim($last);
	( $seq, $n, $winner_so_far ) = split /\s+/, $last;
	$winner_so_far =~ s/\D//g;
	say "SEQ: $seq N: $n W: $winner_so_far";
	}
else {
	die "Could not open $file: $!";
	}
$n++;

exit;

open my $out_fh, '>', $file or die "Could not open <$file> for writing: $!";
print "\n"; # just to ensure we are on a fresh line

$SIG{'INT'} = sub { exit };

while(1) {
	state $n = $ARGV[0] // 1;
	state $sequence = 1;

	next if( $n > 60 and $n % 10 );
	my @d = divisors($n);
	next unless @d > $winner_so_far;
	$seq++;

	$winner_so_far = @d;

	say {$out_fh} "$seq $n ($winner_so_far): @d";
	}

# 897612484786617600
# 1102701600
# 128501493120
