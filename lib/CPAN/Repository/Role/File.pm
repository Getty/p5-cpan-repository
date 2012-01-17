package CPAN::Repository::Role::File;
# ABSTRACT: Adding functionality to compress the given file also

use Moo::Role;

use File::Path qw( make_path );
use File::Spec::Functions ':ALL';
use IO::Zlib;
use IO::File;
# makes 00-load.t fail on test in dev
#use utf8::all;

requires qw( file_parts generate_content );

has repository_root => (
	is => 'ro',
	required => 1,
);

has generate_uncompressed => (
	is => 'ro',
	lazy => 1,
	builder => '_build_generate_uncompressed',
);

sub _build_generate_uncompressed { 1 }

sub path_inside_root {
	my ( $self ) = @_;
	return join("/",$self->file_parts);
}

sub compressed_path_inside_root {
	my ( $self ) = @_;
	return join("/",$self->file_parts).".gz";
}

sub full_filename {
	my ( $self ) = @_;
	return catfile( splitdir($self->repository_root), $self->file_parts );
}

sub full_compressed_filename { shift->full_filename.".gz" }

sub exist {
	my ( $self ) = @_;
	return 0 unless -f $self->full_compressed_filename;
	return 1;
}

sub save {
	my ( $self ) = @_;
	my @pps = $self->file_parts;
	pop(@pps);
	$self->mkdir( splitdir( $self->repository_root ), @pps ) unless -d catdir( $self->repository_root, @pps );
	my $content = $self->generate_content;
	my $gz = IO::Zlib->new($self->full_compressed_filename, "w") or die "cant write to ".$self->full_compressed_filename;
	print $gz $content;
	$gz->close;
	if ($self->generate_uncompressed) {
		my $txt = IO::File->new($self->full_filename, "w") or die "cant write to ".$self->full_filename;
		print $txt $content;
		$txt->close;
	}
	return 1;
}

sub get_file_lines {
	my ( $self ) = @_;
	my $gz = IO::Zlib->new($self->full_compressed_filename, "r") or die "cant read ".$self->full_compressed_filename;
	return <$gz>;
}

sub mkdir {
	my ( $self, @path ) = @_;
	make_path(catdir(@path),{ error => \my $err });
	if (@$err) {
		for my $diag (@$err) {
			my ($file, $message) = %$diag;
			if ($file eq '') {
				die "general error: $message\n";
			} else {
				die "problem making path $file: $message\n";
			}
		}
	}
}

1;