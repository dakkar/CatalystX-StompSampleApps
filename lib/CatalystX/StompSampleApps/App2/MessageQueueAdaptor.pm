package CatalystX::StompSampleApps::App2::MessageQueueAdaptor;
use Moose;
extends 'CatalystX::ComponentsFromConfig::ModelAdaptor';
use JSON::XS;

my $json = JSON::XS->new->utf8;

__PACKAGE__->config(
    class => 'Net::Stomp::Producer',
    args => {
        serializer => sub { $json->encode($_[0]) },
        default_headers => {
            'content-type' => 'json',
            persistent => 'true',
        },
        schema => CatalystX::StompSampleApps::App2->model('DB'),
    },
);

1;
