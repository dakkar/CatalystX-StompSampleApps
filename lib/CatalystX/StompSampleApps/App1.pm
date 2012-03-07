package CatalystX::StompSampleApps::App1;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    ConfigLoader
    +CatalystX::ComponentsFromConfig::ModelPlugin
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'CatalystX::StompSampleApps::App1',
    disable_component_resolution_regex_fallback => 1,
);

__PACKAGE__->setup();

1;
