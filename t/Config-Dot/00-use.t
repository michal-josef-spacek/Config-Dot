# Pragmas.
use strict;
use warnings;

# Modules.
use Test::More 'tests' => 2;

BEGIN {

	# Test.
	use_ok('Config::Dot');
}

# Test.
require_ok('Config::Dot');
