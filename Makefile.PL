# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Module for simple configure file parsing.';
author 'Michal Špaček <skim@cpan.org>';
license 'bsd';
name 'Cnf-Dot';
requires 'Class::Utils' => 0.02;
requires 'Cnf::Utils' => 0;
requires 'Error::Pure' => 0.05;
requires 'Readonly' => 0;
resources 'repository' => {
	'url' => 'git://github.com/tupinek/Cnf-Dot',
	'web' => 'https://github.com/tupinek/Cnf-Dot',
	'type' => 'git',
};
test_requires 'English' => 0;
test_requires 'File::Object' => 0.01;
test_requires 'Test::More' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
