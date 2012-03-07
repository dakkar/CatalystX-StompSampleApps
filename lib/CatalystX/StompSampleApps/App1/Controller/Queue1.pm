package CatalystX::StompSampleApps::App1::Controller::Queue1;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::JMS' }

__PACKAGE__->config(namespace => 'queue/test-1');

sub something :MessageTarget('type2') {
    my ($self,$c) = @_;

    my $msg = $c->req->data;
    if ($msg->{state} eq '3') {
        $c->model('MessageQueue')->transform_and_send(
            $c->model('Producer::Type3'),
            4,
        );
    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;
