#!/usr/bin/env perl
use strict;
use warnings;
use 5.014;
use FindBin;
use FindBin::libs;
use Net::Stomp::Producer;
use Config::Any;

$ENV{CATALYST_CONFIG} //= "$FindBin::Bin/../app2.conf";
$ENV{CATALYST_HOME} //= "$FindBin::Bin/..";
require CatalystX::StompSampleApps::App2;
my $db = CatalystX::StompSampleApps::App2->model('DB');
$db->schema->deploy();

