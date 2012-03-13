package CatalystX::StompSampleApps::App2::Consumer::Event;
use Moose;
use Try::Tiny;
extends 'CatalystX::StompSampleApps::App2::Base::Consumer';

sub routes {
    return {
        'events' => {
            'event-msg' => {
                code => \&consume_event,
                validate => \&validate_event,
            },
        },
    };
}

sub validate_event {
    my ($self,$headers,$body) = @_;

    my $ok;
    try {
        $ok = defined $body->{event_text};
    };
    die 'bad message' unless $ok;
}

sub consume_event {
    my ($self,$headers,$body) = @_;

    $self->app->log->info("received @{[ %$body ]}");

    $self->app->model('DB::Events')->create({
        text => $body->{event_text},
    });
}

1;
