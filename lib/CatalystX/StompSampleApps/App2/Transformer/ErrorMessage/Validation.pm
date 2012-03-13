package CatalystX::StompSampleApps::App2::Transformer::ErrorMessage::Validation;
use strict;
use warnings;

sub transform {
    my ($class,$destination,$type,$headers,$message,$exception)=@_;

    my @headers;$headers->scan(sub{push @headers,\@_});
    my $payload = {
        headers => \@headers,
        body => $message,
        exception => $exception, # this will have problems with exception objects!
    };
    my $output_headers = {
        destination => "/queue/DLQ.failed-validation.$destination",
        type => "fail-$type",
    };
    return $output_headers,$payload;
}

1;
