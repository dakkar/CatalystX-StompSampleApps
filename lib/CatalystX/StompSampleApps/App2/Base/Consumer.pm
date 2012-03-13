package CatalystX::StompSampleApps::App2::Base::Consumer;
use Moose;
use Try::Tiny;
extends 'Catalyst::Component';
with 'CatalystX::ConsumesJMS';

has app => ( is => 'rw' );

sub _kind_name {'Consumer'}
sub _wrap_code {
    my ($self,$c,$destination_name,$msg_type,$route) = @_;

    my $code = $route->{code};
    my $validate = $route->{validate};

    return sub {
        my ($controller,$c) = @_;

        $self->app($c);

        my $message = $c->req->data;
        my $headers = $c->req->headers;

        try {
            $self->$validate($headers,$message);
        }
        catch {
            $c->log->error("validation failed: $_");
            $c->model('MessageQueue')->transform_and_send(
                'CatalystX::StompSampleApps::App2::Transformer::ErrorMessage::Validation',
                $destination_name,$msg_type,$headers,$message,$_,
            );
        };
        try {
            $self->$code($headers,$message);
        }
        catch {
            $c->log->error("processing failed: $_");
            $c->model('MessageQueue')->transform_and_send(
                'CatalystX::StompSampleApps::App2::Transformer::ErrorMessage::Processing',
                $destination_name,$msg_type,$headers,$message,$_,
            );
        };

        return;
    };
}

1;
