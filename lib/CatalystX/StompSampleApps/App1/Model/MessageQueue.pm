package CatalystX::StompSampleApps::App1::Model::MessageQueue;
use base 'Catalyst::Model::Adaptor';
use JSON::XS;

my $json = JSON::XS->new->utf8;

__PACKAGE__->config(
    class => 'Net::Stomp::Producer',
    args => {
        serializer => sub { $json->encode($_[0]) },
        default_headers => {
            'content-type' => 'json',
        },
    },
);

1;
