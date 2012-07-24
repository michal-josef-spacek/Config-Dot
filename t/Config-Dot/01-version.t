# Pragmas.
use strict;
use warnings;

# Modules.
use Config::Dot;
use Test::More 'tests' => 1;

# Test.
is($Config::Dot::VERSION, 0.03, 'Version.');
