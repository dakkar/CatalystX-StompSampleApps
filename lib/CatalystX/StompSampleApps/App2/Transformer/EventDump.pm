package CatalystX::StompSampleApps::App2::Transformer::EventDump;
use Moose;

# this Transformer gets events from the database, and sends them

# this parameter will be set by our ::Model::MessageQueue, see
# CatalystX::StompSampleApps::App2::MessageQueueAdaptor
has schema => (is => 'ro',required => 1);

# some validation for the just-produced message
sub validate {
    my ($self,$headers,$body) = @_;

    die "not an arrayref\n" unless ref($body) eq 'ARRAY';
}

sub transform {
    my ($self,$destination) = @_;

    # get all the events, as hashrefs
    my @events = $self->schema->resultset('Events')->search(
        {},
        {
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        })->all;

    # create the message
    return {
        destination => $destination,
        type => 'event-dump',
    },
        \@events;
}

1;
