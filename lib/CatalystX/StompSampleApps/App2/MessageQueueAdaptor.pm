package CatalystX::StompSampleApps::App2::MessageQueueAdaptor;
use Moose;
extends 'CatalystX::ComponentsFromConfig::ModelAdaptor';
use JSON::XS;

# this is the base class we use for our MessageQueue model

# we do it this way, instead of just writing the Model class, to be
# able to easily:
#
# * have more than one Net::Stomp::Producer model
#
# * add the Net::Stomp::MooseHelpers::TraceStomp or
#   Net::Stomp::MooseHelpers::TraceOnly traits

my $json = JSON::XS->new->utf8;

__PACKAGE__->config(
    class => 'Net::Stomp::Producer',
    args => {
        serializer => sub { $json->encode($_[0]) },
        default_headers => {
            'content-type' => 'json',
            persistent => 'true',
        },
        # some argument to use when instantiating a transformer, just
        # to show that it can be done
        transformer_args => {
            schema => CatalystX::StompSampleApps::App2->model('DB'),
        },
    },
);

1;
