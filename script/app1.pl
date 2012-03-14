#!/usr/bin/env perl
use strict;
use warnings;
use 5.014;
use Plack::Handler::Stomp;
use FindBin;
use FindBin::libs;

# let's load the application, using the default locations for home & config

$ENV{CATALYST_CONFIG} //= "$FindBin::Bin/../app1.conf";
$ENV{CATALYST_HOME} //= "$FindBin::Bin/..";
require CatalystX::StompSampleApps::App1;

my $appclass = 'CatalystX::StompSampleApps::App1';

# we will connect to the same servers as the application uses to send
# messages
my $servers = $appclass->model('MessageQueue')
    ->servers;

# we extract namespaces & destinations from the application controllers
my @namespaces = map { $appclass->controller($_)->action_namespace }
    $appclass->controllers;
my @subscriptions = map {; {
    destination => '/'.$_,
} } grep { m{^(queue|topic)}x } @namespaces;

# now we can build the handler
my $handler = Plack::Handler::Stomp->new({
    servers => $servers,
    subscriptions => \@subscriptions,
});

# and have it run our application
if ($appclass->can('psgi_app')) {
    $handler->run($appclass->psgi_app);
}
else {
    $appclass->setup_engine('PSGI');
    $handler->run( sub { $appclass->run(@_) } );
}
