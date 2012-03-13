package CatalystX::StompSampleApps::App2::Consumer::Command;
use Moose;
use Try::Tiny;
extends 'CatalystX::StompSampleApps::App2::Base::Consumer';

# a Consumer

sub routes {
    return {
        'commands' => { # this is a destination name, see the
                        # configuration for the value that's actually
                        # used
            'dump-events' => {
                code => \&consume_dump,
                validate => \&validate_dump,
            },
            'dump-to-queue' => {
                code => \&consume_dumpq,
                validate => \&validate_dumpq,
            },
        },
    };
}

# this should do some validation, but I'm lazy
sub validate_dump { 1 }

# here is proper validation: we need a destination name
sub validate_dumpq {
    my ($self,$headers,$body) = @_;

    my $ok;
    try {
        $ok = defined $body->{destination}
            && $body->{destination} =~ m{/(?:queue|topic)/};
    };
    die 'bad message' unless $ok;
}

# dump the events to the log
sub consume_dump {
    my ($self,$headers,$body) = @_;

    my $rs = $self->app->model('DB::Events')->search({});

    while (my $record = $rs->next) {
        $self->app->log->info(sprintf 'Event %d: <%s>',
                              $record->id,$record->text);
    }
}

# dump the events to the given destination
sub consume_dumpq {
    my ($self,$headers,$body) = @_;

    # note that the Transformer is doing all the work
    $self->app->model('MessageQueue')->transform_and_send(
        'CatalystX::StompSampleApps::App2::Transformer::EventDump',
        $body->{destination},
    );
}

1;
