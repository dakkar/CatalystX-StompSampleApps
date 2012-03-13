package CatalystX::StompSampleApps::App2;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# plugins! CatalystX::ComponentsFromConfig::ModelPlugin is used to
# generate models without having to write mostly-empty classes
use Catalyst qw/
    -Debug
    ConfigLoader
    +CatalystX::ComponentsFromConfig::ModelPlugin
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'CatalystX::StompSampleApps::App2',
    disable_component_resolution_regex_fallback => 1,
    # this will make Catalyst load our special Consumer components,
    # see lib/CatalystX/StompSampleApps/App2/Consumer/*.pm
    setup_components => {
        search_extra => [ '::Consumer' ],
    },
);

__PACKAGE__->setup();

1;
