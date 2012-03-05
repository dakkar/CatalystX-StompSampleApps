package CatalystX::StompSampleApps::App1::Producer::Type2;

sub transform {
    my ($class,$state) = @_;

    return {
        destination => 'queue/test-1',
        type => 'type2',
    },{
        state => $state,
    };
}

1;
