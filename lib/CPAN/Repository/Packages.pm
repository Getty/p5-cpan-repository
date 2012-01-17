package CPAN::Repository::Packages;
# ABSTRACT: 02packages

use Moo;

with qw(
	CPAN::Repository::Role::File
);

use Dist::Data;
use File::Spec::Functions ':ALL';

sub file_parts { 'modules', '02packages.details.txt' }

has modules => (
	is => 'ro',
	lazy => 1,
	builder => '_build_modules',
);

sub _build_modules {
	my ( $self ) = @_;
	return {} unless $self->exist;
	my @lines = $self->get_file_lines;
	my %modules;
	for (@lines) {
		chomp($_);
		next if ($_ =~ /[^:]:[ \t]/);
		if ($_ =~ m/^([^ \t]+)[ \t]+([^ \t]+)[ \t]+([^ \t]+)$/) {
			# $1 = module
			# $2 = version
			# $3 = path (inside repository)
			$modules{$1} = [ $2, $3 ];
		}
	}
	return \%modules;
}

has authorbase_path_parts => (
	is => 'ro',
	required => 1,
);

has url => (
	is => 'ro',
	required => 1,
);

has written_by => (
	is => 'ro',
	required => 1,
);

sub set_module {
	my ( $self, $module, $version, $path ) = @_;
	return $self->modules->{$module} = [ $version, $path ];
}

sub add_distribution {
	my ( $self, $author_distribution_path ) = @_;
	my $filename = catfile( $self->repository_root, @{$self->authorbase_path_parts}, splitdir( $author_distribution_path ) );
	my $dist = Dist::Data->new( $filename );
	for (keys %{$dist->packages}) {
		$self->set_module($_, $dist->packages->{$_}->{version}, $author_distribution_path);
	}
	return $self;
}

sub generate_content {
	my ( $self ) = @_;
	my @file_parts = $self->file_parts;
	my $content = "";
	$content .= $self->generate_header_line('File:',(pop @file_parts));
	$content .= $self->generate_header_line('URL:',$self->url.$self->path_inside_root);
	$content .= $self->generate_header_line('Description:','Package names found in directory $CPAN/authors/id/');
	$content .= $self->generate_header_line('Columns:','package name, version, path');
	$content .= $self->generate_header_line('Intended-For:','Automated fetch routines, namespace documentation.');
	$content .= $self->generate_header_line('Written-By:',$self->written_by);
	$content .= $self->generate_header_line('Line-Count:',scalar keys %{$self->modules});
	$content .= $self->generate_header_line('Last-Updated:',DateTime->now->strftime('%a, %e %b %y %T %Z'));
	$content .= "\n";
	for (keys %{$self->modules}) {
		$content .= sprintf("%-60s %-20s %s\n",$_,$self->modules->{$_}->[0],$self->modules->{$_}->[1]);
	}
	return $content;
}

sub generate_header_line {
	my ( $self, $key, $value ) = @_;
	return sprintf("%-13s %s\n",$key,$value);
}

1;