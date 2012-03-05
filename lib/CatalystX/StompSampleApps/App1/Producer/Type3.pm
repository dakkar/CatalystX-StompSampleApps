package CatalystX::StompSampleApps::App1::Producer::Type3;
use base 'Catalyst::Component';
use Moose;
use namespace::autoclean;

has destination => (
    is => 'rw',
    isa => 'Str',
    default => 'wrong-place',
);

sub transform {
    my ($self,$state) = @_;

    return {
        destination => $self->destination,
        type => 'type3',
    },{
        state => $state,
    };
}

1;
