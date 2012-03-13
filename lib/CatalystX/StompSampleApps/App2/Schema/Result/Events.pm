package CatalystX::StompSampleApps::App2::Schema::Result::Events;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('events');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_nullable => 0,
        is_auto_increment => 1,
        is_numeric => 1,
    },
    text => {
        data_type => 'varchar',
        is_nullable => 0,
    },
);
__PACKAGE__->set_primary_key('id');

1;

