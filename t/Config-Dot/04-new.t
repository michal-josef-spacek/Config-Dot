# Pragmas.
use strict;
use warnings;

# Modules.
use Config::Dot;
use English qw(-no_match_vars);
use Test::More 'tests' => 4;

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
is($EVAL_ERROR, "Config parameter must be a reference to hash.\n",
	'Bad \'config\' parameter.');
