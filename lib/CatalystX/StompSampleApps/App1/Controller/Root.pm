package CatalystX::StompSampleApps::App1::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

__PACKAGE__->meta->make_immutable;

1;
