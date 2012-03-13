package CatalystX::StompSampleApps::App2::Base::Consumer;
use Moose;
use 5.014;
use Try::Tiny;
extends 'Catalyst::Component';
with 'CatalystX::ConsumesJMS';

# base component class for Consumers, see CatalystX::ConsumesJMS for
# explanations

# this attribute is used to let Consumer modules access the Catalyst
# context. In a better-designed example, we should really only expose
# some pieces of the application via delegate methods
has app => ( is => 'rw' );

sub _kind_name {'Consumer'}
sub _wrap_code {
    my ($self,$c,$destination_name,$msg_type,$route) = @_;

    my $code = $route->{code};
    my $validate = $route->{validate};

    # here's the Catalyst action that will be installed
    return sub {
        my ($controller,$c) = @_;

        # set the context
        $self->app($c);

        # extract the interesting pieces of the request
        my $message = $c->req->data;
        # this might not be the cleanest way of doing it, see
        # Plack::Handler::Stomp to see where these values come from
        my $psgi_env = $c->req->can('env') ? $c->req->env : $c->engine->env;
        my %headers = map { s/^jms\.//r, $psgi_env->{$_} }
            grep { /^jms\./ } keys $psgi_env;

        # let's try validating the message
        my $valid=0;
        try {
            $self->$validate(\%headers,$message);
            $valid = 1;
        }
        catch {
            $c->log->error("validation failed: $_");
            $c->model('MessageQueue')->transform_and_send(
                'CatalystX::StompSampleApps::App2::Transformer::ErrorMessage',
                {
                    destination => $destination_name,
                    type => $msg_type,
                    headers => \%headers,
                    message => $message,
                    exception => $_,
                    prefix => '.failed-validation',
                }
            );
        };
        return unless $valid;

        # ok, it's valid, process it
        try {
            $self->$code(\%headers,$message);
        }
        catch {
            $c->log->error("processing failed: $_");
            $c->model('MessageQueue')->transform_and_send(
                'CatalystX::StompSampleApps::App2::Transformer::ErrorMessage',
                {
                    destination => $destination_name,
                    type => $msg_type,
                    headers => \%headers,
                    message => $message,
                    exception => $_,
                }
            );
        };

        return;
    };
}

1;
