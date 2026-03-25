#!perl

use v5.40;
use bigint;

use List::Util qw(reduce);
use Math::Prime::Util qw(divisors);

$|++;

my( $max_exponent, $max_window ) = @ARGV;
$max_exponent //= 13;

my @primes = (
	2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,
	53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101
	);
$max_window //= $#primes;

my @RESULTS;

for( my $window = 1; $window < @primes ; $window++  ) {
	my @arrays = [ (1) x $window ];
	push @arrays, generate( [ (1) x $window ], 0, $max_exponent );

	# A couple of special cases
	push( @arrays, map { [$_] } 2 .. $max_exponent ) if $window == 1;
	splice @arrays, 2, 0, [2, 2]        if $window == 2;

	foreach my $array ( @arrays ) {
		my $product = reduce { $a * $b } map { $primes[$_] ** $array->[$_] } 0 .. $array->$#*;
		my @d = divisors($product);
		my $count = @d;

		push @RESULTS,
			[
			$array,
			( reduce { $a * $b } map { $primes[$_] ** $array->[$_] } 0 .. $array->$#* ),
			$count,
			\@d
			];
		}

	last if $window >= $max_window;
	}

my $last_commit = `git rev-parse HEAD`;
chomp $last_commit;

my $git_branch = `git branch --show-current`;
chomp $git_branch;

my $git_status = `git diff-index --quiet HEAD -- || echo "dirty"`;
chomp $git_status;
$git_status = 'clean' unless length $git_status;

my $header = <<~"HERE";
Highly composite numbers
https://github.com/briandfoy/highly_composite_numbers
SHA $last_commit (branch $git_branch) ($git_status)
Produced by $0 on @{[scalar localtime]}

Run time: @{[ time - $^T ]} seconds
Max prime number: $primes[$max_window - 1]
Max exponent: $max_exponent

@{[ `system_profiler SPHardwareDataType | grep Model`]}
HERE

$header =~ s/^\h*/# /gm;
say $header;

say dump_results(\@RESULTS);

sub commify {
	no warnings 'void';
	local $_  = shift;
	1 while s/^([-+]?\d+)(\d{3})/$1,$2/;
	return $_;
}

sub dumper { state $rc = require Data::Dumper; Data::Dumper->new([@_])->Indent(1)->Sortkeys(1)->Terse(1)->Useqq(1)->Dump }

=pod

The exponents must be weakly decreasing, and the last exponent in the group
must be one.

=cut


sub generate ( $array, $cursor, $max ) {
	return if $cursor == $array->$#*;

	my @results;

	foreach my $i ( 2 .. $max ) {
		my @b = $array->@*;
		next if( $cursor > 0 and $i > $b[$cursor - 1] );
		$b[$cursor] = $i;
		push @results, \@b;
		push @results, generate( \@b, $cursor + 1, $max )
		}

	return @results;
	}

sub dump_arrays ($arrays) {
	foreach my $a ($arrays->@*) {
		say join " ", $a->@*;
		}
	}

sub dump_results ($arrays) {
	my $seq = 0;
	my $floor = 0;

	foreach my $a ( sort { $a->[1] <=> $b->[1] or $a->[2] <=> $b->[2] } $arrays->@*) {
		my( $exponents, $product, $count, $divisors ) = $a->@*;
		next unless $count > $floor;

		my $factors = join ' * ', map { "$primes[$_]^$exponents->[$_]" } 0 .. $exponents->$#*;

		$floor = $count;
		$seq++;
		print "\n" unless $seq % 5;
		printf "%4d %10d   %-50s  %55s  |  %s\n", $seq, $count, $factors, commify($product), "";
		}

	}



__END__



	my @factors = map { [ [$bases[$_], $exponents[$_], $bases[$_]**$exponents[$_] ] } 0 .. $#bases;
	my $n = reduce { $a + $b } map { $_->[-1] } @factors;
	say $n;

	say "PRIMES: @bases";


for( my $i = 0; $i < @first100; $i++ ) {
	foreach my $item (@number) {
		push @new_hcn, $item;

		my($num, $= 1ivisors, $exponents) = $item->@*;

		next if @$exp_ref < $i;

		my $e_max;
		if ($i >= 1) {
			$e_max = $exp_ref->[$i-1];
		} else {
			# int(log(MAXN, 2))
			$e_max = int(log($MAXN) / log(2));
		}

		my $n = $num;

		for (my $e = 1; $e <= $e_max; $e++) {
			$n *= $primes[$i];
			last if $n > $MAXN;

			my $div = $divs * ($e + 1);
			my @exponents = (@$exp_ref, $e);

			push @new_hcn, [$n, $div, \@exponents];
		}
	}

	@new_hcn = sort {
		   $a->[0] <=> $b->[0]
		|| $a->[1] <=> $b->[1]
	} @new_hcn;

	@hcn = ([1, 1, []]);

	for my $el (@new_hcn) {
		if ($el->[1] > $hcn[-1]->[1]) {
			push @hcn, $el;
		}
	}
}

__END__
def gen_hcn():
    # List of (number, number of divisors, exponents of the factorization)
	hcn = [(1, 1, [])]
	for i in range(len(primes)):
		new_hcn = []
		for el in hcn:
			new_hcn.append(el)
			if len(el[2]) < i: continue
			e_max = el[2][i-1] if i >= 1 else int(log(MAXN, 2))
			n = el[0]
			for e in range(1, e_max+1):
				n *= primes[i]
				if n > MAXN: break
				div = el[1] * (e+1)
				exponents = el[2] + [e]
				new_hcn.append((n, div, exponents))
		new_hcn.sort()
		hcn = [(1, 1, [])]
		for el in new_hcn:
			if el[1] > hcn[-1][1]: hcn.append(el)
	return hcn
