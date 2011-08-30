# Pragmas.
use strict;
use warnings;

# Modules.
use Config::Dot;
use Test::More 'tests' => 2;

# Test.
my $c = Config::Dot->new(
	'config' => {
		'key' => 'value',
	},
);
is($c->serialize, 'key=value', 'Serialize simple key, value pair.');

# Test.
$c = Config::Dot->new(
	'config' => {
		'key' => {
			'subkey' => 'value',
		},
	},
);
my $right_ret = <<'END';
key.subkey=value
END
chomp $right_ret;
is($c->serialize, $right_ret, 'Serialize key with subkey.');
