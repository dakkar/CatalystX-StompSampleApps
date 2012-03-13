package CatalystX::StompSampleApps::App2::Transformer::ErrorMessage::Processing;
use strict;
use warnings;
use Scalar::Util 'blessed';

sub transform {
    my ($class,$destination,$type,$headers,$message,$exception)=@_;

    my @headers;$headers->scan(sub{push @headers,\@_});

    if (blessed($exception)) { $exception="$exception" }

    my $payload = {
        headers => \@headers,
        body => $message,
        exception => $exception,
    };
    my $output_headers = {
        destination => "/queue/DLQ.$destination",
        type => "fail-$type",
    };
    return $output_headers,$payload;
}

1;
