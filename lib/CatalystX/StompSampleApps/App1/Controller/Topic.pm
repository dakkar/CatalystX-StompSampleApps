package CatalystX::StompSampleApps::App1::Controller::Topic;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::JMS' }

__PACKAGE__->config(namespace => 'topic/test-1');

sub type1 :MessageTarget {
    my ($self,$c) = @_;

    my $msg = $c->req->data;
    if ($msg->{state} eq '2') {
        $c->model('MessageQueue')->send(
            'queue/test-1',
            { type => 'type2' },
            { state => '3' },
        );
    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;
