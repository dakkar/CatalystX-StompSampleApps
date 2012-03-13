#!/usr/bin/env perl
use strict;
use warnings;
use 5.014;
use Plack::Handler::Stomp;
use FindBin;
use FindBin::libs;

$ENV{CATALYST_CONFIG} //= "$FindBin::Bin/../app2.conf";
$ENV{CATALYST_HOME} //= "$FindBin::Bin/..";
require CatalystX::StompSampleApps::App2;

my $appclass = 'CatalystX::StompSampleApps::App2';

my $servers = $appclass->model('MessageQueue')
    ->servers;

my @namespaces = map { $appclass->controller($_)->action_namespace }
    $appclass->controllers;

my @subscriptions = map {; {
    destination => '/'.$_,
} } grep { m{^(queue|topic)}x } @namespaces;

my $handler = Plack::Handler::Stomp->new({
    servers => $servers,
    subscriptions => \@subscriptions,
});

$handler->run($appclass->psgi_app);
