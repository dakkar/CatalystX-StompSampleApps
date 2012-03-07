#!/usr/bin/env perl
use strict;
use warnings;
use 5.014;
use FindBin;
use FindBin::libs;
use Net::Stomp::Producer;
use Config::Any;

$ENV{CATALYST_CONFIG} //= "$FindBin::Bin/../app1-nonet.conf";
$ENV{CATALYST_HOME} //= "$FindBin::Bin/..";
require CatalystX::StompSampleApps::App1;
my $prod = CatalystX::StompSampleApps::App1->model('MessageQueue');

$prod->send(
    'topic/test-1',
    { type => 'type1' },
    { state => '2' },
);

