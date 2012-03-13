#!/usr/bin/env perl
use strict;
use warnings;
use 5.014;
use FindBin;
use FindBin::libs;
use Net::Stomp::Producer;
use Config::Any;

# this script sends a "dump-events" message to have the application
# dump (to the log or to a queue) the events it received

$ENV{CATALYST_CONFIG} //= "$FindBin::Bin/../app2.conf";
$ENV{CATALYST_HOME} //= "$FindBin::Bin/..";
require CatalystX::StompSampleApps::App2;
my $prod = CatalystX::StompSampleApps::App2->model('MessageQueue');

# if you call this script with a parameter like "/queue/dumps", the
# dump will be sent to that destination, otherwise it will just be
# logged

$prod->send(
    # this gets the queue from the configuration
    CatalystX::StompSampleApps::App2->config->
          {'Consumer::Command'}{routes_map}{commands},
    ( $ARGV[0] ? (
        {type => 'dump-to-queue'},
        {destination => $ARGV[0]},
    ) : (
        { type => 'dump-events' },
        {},
    ) )
);
