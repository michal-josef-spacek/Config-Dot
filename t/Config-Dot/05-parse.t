# Pragmas.
use strict;
use warnings;

# Modules.
use Config::Dot;
use English qw(-no_match_vars);
use Test::More 'tests' => 3;

# Test.
my $c = Config::Dot->new;
my $ret = $c->parse(<<'END');

# comment
=value
key=value
END
is_deeply(
	$ret, 
	{
		'key' => 'value',
	},
	'Parse simple key, value pair.',
);

# Test.
$c->reset;
$ret = $c->parse(['key1=value1', 'key2=value2']);
is_deeply(
	$ret,
	{
		'key1' => 'value1',
		'key2' => 'value2',
	},
	'Parse key, value pairs from array reference.',
);

# Test.
$c->reset;
eval {
	$c->parse(';=');
};
is($EVAL_ERROR, "Bad key ';' in string ';=' at line '1'.\n");
