package CatalystX::StompSampleApps::App1::Controller::Queue2;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::JMS' }

sub type3 :MessageTarget {
    my ($self,$c) = @_;

    my $msg = $c->req->data;
    if ($msg->{state} eq '4') {
        $c->log->info("GOT IT");
    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;
