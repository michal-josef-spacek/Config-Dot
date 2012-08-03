package Config::Dot;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Config::Utils qw(hash);
use English qw(-no_match_vars);
use Error::Pure qw(err);
use Readonly;

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};

# Version.
our $VERSION = 0.04;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Callback.
	$self->{'callback'} = undef;

	# Config hash.
	$self->{'config'} = {};

	# Set conflicts detection as error.
	$self->{'set_conflicts'} = 1;

	# Process params.
	set_params($self, @params);

	# Check config hash.
	if (! $self->_check($self->{'config'})) {
		err 'Bad \'config\' parameter.';
	}

	# Check callback.
	if (defined $self->{'callback'} && ref $self->{'callback'} ne 'CODE') {
		err 'Parameter \'callback\' isn\'t code reference.';
	}

	# Count of lines.
	$self->{'count'} = 0;

	# Stack.
	$self->{'stack'} = [];

	# Object.
	return $self;
}

# Parse text or array of texts.
sub parse {
	my ($self, $string_or_array_ref) = @_;
	my @text;
	if (ref $string_or_array_ref eq 'ARRAY') {
		@text = @{$string_or_array_ref};
	} else {
		@text = split m/$INPUT_RECORD_SEPARATOR/sm,
			$string_or_array_ref;
	}
	foreach my $line (@text) {
		$self->{'count'}++;
		$self->_parse($line);
	}
	return $self->{'config'};
}

# Reset content.
sub reset {
	my $self = shift;
	$self->{'config'} = {};
	$self->{'count'} = 0;
	return;
}

# Serialize.
sub serialize {
	my $self = shift;
	return join $INPUT_RECORD_SEPARATOR,
		$self->_serialize($self->{'config'});
}

# Check structure.
sub _check {
	my ($self, $config_hr) = @_;
	if (ref $config_hr eq 'HASH') {
		foreach my $key (sort keys %{$config_hr}) {
			if (ref $config_hr->{$key} ne ''
				&& ! $self->_check($config_hr->{$key})) {

				return 0;
			}
		}
		return 1;
	} else {
		return 0;
	}
}

# Parse string.
sub _parse {
	my ($self, $string) = @_;

	# Remove comments on single line.
	$string =~ s/^\s*#.*$//sm;

	# Blank space.
	if ($string =~ m/^\s*$/sm) {
		return 0;
	}

	# Split.
	my ($key, $val) = split m/=/sm, $string, 2;

	# Not a key.
	if (length $key < 1) {
		return 0;
	}

	# Bad key.
	if ($key !~ m/^[-\w\.:,]+\+?$/sm) {
		err "Bad key '$key' in string '$string' at line ".
			"'$self->{'count'}'.";
	}

	my @tmp = split m/\./sm, $key;
	hash($self, \@tmp, $val);

	# Ok.
	return 1;
}

# Serialize.
sub _serialize {
	my ($self, $config_hr) = @_;
	my @ret;
	foreach my $key (sort keys %{$config_hr}) {
		if (ref $config_hr->{$key} eq 'HASH') {
			my @subkey = $self->_serialize($config_hr->{$key});
			foreach my $subkey (@subkey) {
				push @ret, $key.'.'.$subkey;
			}
		} else {
			push @ret, $key.'='.$config_hr->{$key};
		}
	}
	return @ret;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Config::Dot - Module for simple configure file parsing.

=head1 SYNOPSIS

 my $cnf = Config::Dot->new(%params);
 my $struct_hr = $cnf->parse($string);
 $cnf->reset;
 my $serialized = $cnf->serialize;

=head1 METHODS

=over 8

=item B<new(%params)>

 Constructor.

=over 8

=item * B<callback>

 Callback code for adding parameter.
 Callback arguments are:
 $key_ar - Reference to array with keys.
 $value - Key value.
 Default is undef.

=item * B<config>

 Reference to hash structure with default config data.
 This is hash of hashes structure.
 Default value is reference to blank hash.

=item * B<set_conflicts>

 Set conflicts detection as error.
 Default value is 1.

=back

=item B<parse($string_or_array_ref)>

Parse string $string_or_array_ref or reference to array 
$string_or_array_ref and returns hash structure.

=item B<reset()>

Reset content in class (config parameter).

=item B<serialize()>

Serialize 'config' hash to output.

=back

=head1 PARAMETER_FILE

 # Comment.
 # blabla

 # White space.
 /^\s*$/

 # Parameters.
 # Key must be '[-\w\.:,]+'.
 # Separator is '='.
 key=val
 key2.subkey.subkey=val

=head1 ERRORS

 Mine:
         Bad 'config' parameter.
         Parameter 'callback' isn't code reference.

 From Class::Utils::set_params():
         Unknown parameter '%s'.

 From Config::Utils::conflict():
         Conflict in '%s'.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Config::Dot;
 use Dumpvalue;

 # Object.
 my $struct_hr = Config::Dot->new->parse(<<'END');
 key1=value1
 key2=value2
 key3.subkey1=value3
 END

 # Dump
 my $dump = Dumpvalue->new;
 $dump->dumpValues($struct_hr);

 # Output:
 # 0  HASH(0x84b98a0)
 #    'key1' => 'value1',
 #    'key2' => 'value2',
 #    'key3' => HASH(0x8da3ab0)
 #       'subkey1' => 'value3',

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Config::Dot;

 # Object with data.
 my $c = Config::Dot->new(
         'config' => {
                 'key1' => {
                         'subkey1' => 'value1',
                 },
                 'key2' => 'value2',
         },
 );

 # Serialize.
 print $c->serialize."\n";

 # Output:
 # key1=subkey1.value1
 # key2=value2

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Config::Dot;
 use Dumpvalue;

 # Object.
 my $struct_hr = Config::Dot->new(
         'callback' => sub {
                my ($key_ar, $value) = @_;
                if ($key_ar->[0] eq 'key3' && $key_ar->[1] eq 'subkey1'
                        && $value eq 'value3') {

                        return 'FOOBAR';
                }
                return $value;
         },
 )->parse(<<'END');
 key1=value1
 key2=value2
 key3.subkey1=value3
 END

 # Dump
 my $dump = Dumpvalue->new;
 $dump->dumpValues($struct_hr);

 # Output:
 # 0  HASH(0x84b98a0)
 #    'key1' => 'value1',
 #    'key2' => 'value2',
 #    'key3' => HASH(0x8da3ab0)
 #       'subkey1' => 'FOOBAR',

=head1 DEPENDENCIES

L<Class::Utils>,
L<Config::Utils>,
L<English>,
L<Error::Pure>,
L<Readonly>.

=head1 SEE ALSO

L<Config::Utils>.

=head1 REPOSITORY

L<https://github.com/tupinek/Config-Dot>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.04

=cut
