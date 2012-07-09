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

sub get_alias {
	my ( $self, $author ) = @_;
	return defined $self->aliases->{$author}
		? $self->aliases->{$author}
		: ();
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


=encoding utf8

=head1 SYNOPSIS

  use CPAN::Repository::Mailrc;

  my $mailrc = CPAN::Repository::Mailrc->new({
    repository_root => $fullpath_to_root,
  });

=head1 SEE ALSO
  
L<CPAN::Repository>

=head1 SUPPORT

IRC

  Join #duckduckgo on irc.freenode.net. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-cpan-repository
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-cpan-repository/issues
