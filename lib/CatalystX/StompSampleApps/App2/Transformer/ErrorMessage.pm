package CatalystX::StompSampleApps::App2::Transformer::ErrorMessage;
use strict;
use warnings;
use Scalar::Util 'blessed';

sub transform {
    my ($class,$opts) = @_;

    my ($destination,$type,$headers,$message,$exception,$prefix)=@$opts{
        qw(destination type headers message exception prefix)
    };
    $prefix//='';

    # cheating! we should probably check if the exception knows how to
    # serialise itself properly
    if (blessed($exception)) { $exception="$exception" }

    my $payload = {
        headers => $headers,
        body => $message,
        exception => $exception,
    };
    my $output_headers = {
        destination => "/queue/DLQ${prefix}.${destination}",
        type => "fail-$type",
    };
    return $output_headers,$payload;
}

1;
