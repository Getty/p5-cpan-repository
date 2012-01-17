package CPAN::Repository::Mailrc;
# ABSTRACT: 01mailrc

use Moo;

with qw(
	CPAN::Repository::Role::File
);

sub file_parts { 'authors', '01mailrc.txt' }

has aliases => (
	is => 'ro',
	lazy => 1,
	builder => '_build_aliases',
);

sub _build_aliases {
	my ( $self ) = @_;
	return {} unless $self->exist;
	my @lines = $self->get_file_lines;
	my %aliases;
	for (@lines) {
		if ($_ =~ m/^alias (\w+) "(.*)"$/) {
			$aliases{$1} = $2;
		}
	}
	return \%aliases;
}

sub set_alias {
	my ( $self, $author, $alias ) = @_;
	$self->aliases->{$author} = $alias;
	return $self;
}

sub generate_content {
	my ( $self ) = @_;
	my $content = "";
	for (sort keys %{$self->aliases}) {
		$content .= 'alias '.$_.' "'.( $self->aliases->{$_} ? $self->aliases->{$_} : $_ ).'"'."\n";
	}
	return $content;
}

1;