#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use FindBin;
use Cwd qw( realpath );
use Dancer qw( :syntax );
#use MyApp;
use Test::WWW::Mechanize::PSGI;
set apphandler => 'PSGI';

my $appdir = realpath( "$FindBin::Bin/.." );
my $mech = Test::WWW::Mechanize::PSGI->new(
	app => sub {
		my $env = shift;
		setting(
			appname => 'MyApp',
			appdir => $appdir,
		);
		load_app 'MyApp';
		config->{environment} = 'test';
		Dancer::Config->load;
		my $request = Dancer::Request->new( env => $env );
		Dancer->dance( $request );
	}
);

$mech->get_ok('/') or diag $mech->content;

done_testing;
