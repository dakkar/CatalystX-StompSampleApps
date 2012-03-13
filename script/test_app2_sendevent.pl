#!/usr/bin/env perl
use strict;
use warnings;
use 5.014;
use FindBin;
use FindBin::libs;
use Net::Stomp::Producer;
use Config::Any;

# this script sends a "event-msg" message to the application which
# will just store it

$ENV{CATALYST_CONFIG} //= "$FindBin::Bin/../app2.conf";
$ENV{CATALYST_HOME} //= "$FindBin::Bin/..";
require CatalystX::StompSampleApps::App2;
my $prod = CatalystX::StompSampleApps::App2->model('MessageQueue');

$prod->send(
    # this gets the queue from the configuration
    CatalystX::StompSampleApps::App2->config->
          {'Consumer::Event'}{routes_map}{events},
    { type => 'event-msg' },
    { event_text => $ARGV[0] // 'random text' },
);
