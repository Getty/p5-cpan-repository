#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);
use File::Temp qw/ tempfile tempdir /;

use CPAN::Repository;

use Data::Dumper;

BEGIN {

	my $tempdir = tempdir;

	{
		my $repo = CPAN::Repository->new({
			dir => $tempdir,
			url => 'http://cpan.universe.org/',
			written_by => '10-simple.t',
		});

		isa_ok($repo,'CPAN::Repository');

		ok(!$repo->is_initialized,'Checking if repo is not initialized');
		
		$repo->initialize;

		ok($repo->is_initialized,'Checking if repo is now initialized');

		$repo->add_author_distribution('ALMIGHTYGOD',"$Bin/data/My-Sample-Distribution-0.003.tar.gz");
		$repo->add_author_distribution('FAMILYGUY',"$Bin/data/My-Other-Sample-0.001.tar.gz");

		my @lines = $repo->packages->get_file_lines;
		
		is(scalar @lines, 11, 'Checking for correct amount of lines in packages');
	}

	my $repo = CPAN::Repository->new({
		dir => $tempdir,
		url => 'http://cpan.universe.org/',
		written_by => '10-simple.t',
	});

	isa_ok($repo,'CPAN::Repository');

	ok($repo->is_initialized,'Checking if repo is still initialized');

	$repo->add_author_distribution('ALMIGHTYGOD',"$Bin/data/My-Sample-Distribution-0.004.tar.gz");

	is_deeply($repo->packages->modules, {
		'My::Other::Sample' => [ '0.001', 'F/FA/FAMILYGUY/My-Other-Sample-0.001.tar.gz' ],
		'My::Sample::Distribution' => [ '0.004', 'A/AL/ALMIGHTYGOD/My-Sample-Distribution-0.004.tar.gz' ]
	},'Checking module state of the repository');

	my @packages_lines = $repo->packages->get_file_lines;

	is(scalar @packages_lines, 11, 'Checking for correct amount of lines in packages');

	my @mailrc_lines = $repo->mailrc->get_file_lines;

	is(scalar @mailrc_lines, 2, 'Checking for correct amount of lines in mailrc');
	
}

done_testing;
