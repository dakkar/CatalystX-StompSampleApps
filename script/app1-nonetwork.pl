#!/usr/bin/env perl
use strict;
use warnings;
use 5.014;
use Plack::Handler::Stomp::NoNetwork;
use FindBin;
use FindBin::libs;

$ENV{CATALYST_CONFIG} //= "$FindBin::Bin/../app1-nonet.conf";
$ENV{CATALYST_HOME} //= "$FindBin::Bin/..";
require CatalystX::StompSampleApps::App1;

my $appclass = 'CatalystX::StompSampleApps::App1';

my $tracedir = $appclass->model('MessageQueue')->trace_basedir;

$tracedir->mkpath;

my @namespaces = map { $appclass->controller($_)->action_namespace }
    $appclass->controllers;

my @subscriptions = map {; {
    destination => '/'.$_,
} } grep { m{^(queue|topic)}x } @namespaces;

my $handler = Plack::Handler::Stomp::NoNetwork->new({
    subscriptions => \@subscriptions,
    trace_basedir => $tracedir,
});

if ($appclass->can('psgi_app')) {
    $handler->run($appclass->psgi_app);
}
else {
    $appclass->setup_engine('PSGI');
    $handler->run( sub { $appclass->run(@_) } );
}
