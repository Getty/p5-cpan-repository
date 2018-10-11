# NAME

CPAN::Repository - API to access a directory which can be served as CPAN repository

[![Build Status](https://travis-ci.org/Getty/p5-cpan-repository.png?branch=master)](https://travis-ci.org/Getty/p5-cpan-repository)

# VERSION

version 0.011

# SYNOPSIS

     use CPAN::Repository;

     my $repo = CPAN::Repository->new({
       dir => '/var/www/greypan.company.org/htdocs/',
       url => 'http://greypan.company.org/',
     });
     
     $repo->initialize unless $repo->is_initialized;
     
     $repo->add_author_distribution('AUTHOR','My-Distribution-0.001.tar.gz');
     $repo->add_author_distribution('AUTHOR2','Other-Dist-0.001.tar.gz','Custom/Own/Path');
     $repo->set_alias('AUTHOR','The author <author@company.org>');
     $repo->set_alias('AUTHOR2','The other author <author@company.org>');
     
     my %modules = %{$repo->modules};
     
     my $fullpath_to_authordir = $repo->authordir('SOMEONE');
    
     my $packages = $repo->packages; # gives back a CPAN::Repository::Packages
     my $mailrc = $repo->mailrc; # gives back a CPAN::Repository::Mailrc

# DESCRIPTION

This module is made for representing a directory which can be used as own CPAN for modules, so it can be a GreyPAN, a DarkPAN or even can be
used to manage a mirror of real CPAN your own way. Some code parts are taken from CPAN::Dark of **CHROMATIC** and [CPAN::Mini::Inject](https://metacpan.org/pod/CPAN::Mini::Inject) of **MITHALDU**.

# SEE ALSO

[CPAN::Repository::Packages](https://metacpan.org/pod/CPAN::Repository::Packages)

[CPAN::Repository::Mailrc](https://metacpan.org/pod/CPAN::Repository::Mailrc)

# SUPPORT

IRC

    Join #duckduckgo on irc.freenode.net. Highlight Getty for fast reaction :).

Repository

    http://github.com/Getty/p5-cpan-repository
    Pull request and additional contributors are welcome

Issue Tracker

    http://github.com/Getty/p5-cpan-repository/issues

# AUTHOR

Torsten Raudssus <torsten@raudss.us> [http://raudss.us/](http://raudss.us/)

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by DuckDuckGo, Inc. [http://duckduckgo.com/](http://duckduckgo.com/).

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
