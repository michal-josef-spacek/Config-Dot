# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Module for simple configure file parsing.';
author 'Michal Špaček <skim@cpan.org>';
license 'bsd';
name 'Config-Dot';
requires 'Class::Utils' => 0.02;
requires 'Config::Utils' => 0.01;
requires 'Error::Pure' => 0.05;
requires 'Readonly' => 0;
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Config-Dot';
resources 'homepage' => 'https://github.com/tupinek/Config-Dot';
resources 'repository' => 'git://github.com/tupinek/Config-Dot';
test_requires 'English' => 0;
test_requires 'File::Object' => 0.03;
test_requires 'Test::More' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
