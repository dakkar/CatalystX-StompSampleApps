package CatalystX::StompSampleApps::App2::Consumer::Command;
use Moose;
use Try::Tiny;
extends 'CatalystX::StompSampleApps::App2::Base::Consumer';

sub routes {
    return {
        'commands' => {
            'dump-events' => {
                code => \&consume_dump,
                validate => \&validate_dump,
            },
        },
    };
}

sub validate_dump { 1 };

sub consume_dump {
    my ($self,$headers,$body) = @_;

    my $rs = $self->app->model('DB::Events')->search({});

    while (my $record = $rs->next) {
        $self->app->log->info(sprintf 'Event %d: <%s>',
                              $record->id,$record->text);
    }
}

1;
