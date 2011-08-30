# Pragmas.
use strict;
use warnings;

# Modules.
use Config::Dot;
use English qw(-no_match_vars);
use Test::More 'tests' => 5;

# Test.
my $obj = Config::Dot->new;
isa_ok($obj, 'Config::Dot');

# Test.
eval {
	Config::Dot->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n", 'Unknown parameter.');

# Test.
eval {
	Config::Dot->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n",
	'Unknown parameter \'something\'.');

# Test.
eval {
	Config::Dot->new('config' => '');
};
is($EVAL_ERROR, "Bad 'config' parameter.\n",
	'Bad \'config\' parameter.');

# Test.
eval {
	Config::Dot->new(
		'config' => {
			'key' => [],
		},
	);
};
is($EVAL_ERROR, "Bad 'config' parameter.\n",
	'Bad \'config\' parameter.');
