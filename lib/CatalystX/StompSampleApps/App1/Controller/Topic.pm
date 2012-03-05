package CatalystX::StompSampleApps::App1::Controller::Topic;
use Moose;
use namespace::autoclean;
use CatalystX::StompSampleApps::App1::Producer::Type2;

BEGIN { extends 'Catalyst::Controller::JMS' }

__PACKAGE__->config(namespace => 'topic/test-1');

sub type1 :MessageTarget {
    my ($self,$c) = @_;

    my $msg = $c->req->data;
    if ($msg->{state} eq '2') {
        $c->model('MessageQueue')->transform_and_send(
            'CatalystX::StompSampleApps::App1::Producer::Type2',
            3,
        );
    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;
