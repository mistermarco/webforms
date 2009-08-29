#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';

my $class = "FB::User";

use_ok('FB');
use_ok($class);

#
# Testing new() constructor
#

my $object = $class->new();
is($object->isa("$class"), 1, "Object of type $class created");

is($object->id, undef, "...has undef ID");
is($object->identifier, undef, "...has undef identifier");
is($object->name, undef, "...has undef name");
is($object->email, undef, "...has undef email address");
is($object->max_forms, $class->defaults('max_forms'), "...has default "
    . $class->defaults('max_forms')
    . " max forms");
is($object->is_active, 1, "...is set to active");

#
# Testing new() constructor with values
#

$object = $class->new(
    id         => '1',
    identifier => 'identifier',
    name       => 'name',
    email      => 'email',
    max_forms  => '100',
    is_active  => '0',
);

is($object->isa("$class"), 1, "Object of type $class created, with values");

is($object->id, undef, "id is ignored");
is($object->identifier, 'identifier', "identifer is set");
is($object->name, 'name', "name is set");
is($object->email, 'email', "email is set");
is($object->max_forms, 100, "max_forms is set");
is($object->is_active, 0, "is_active is set");

#
# Testing Accessors
#

$object = $class->new();
$object->{'_id'} = '123';
is($object->id, '123', "id works");

$object = $class->new();
$object->set_name('new name');
is($object->name, 'new name', "set_name/name work");

$object = $class->new();
$object->set_name();
is($object->name, undef, 'set_name/name works with undef');


#
# Testing can_endit
#

$object = $class->new();
eval {
    $object->can_edit();    
};
isnt($@,undef,"calling can_edit with no user ID throws an error: " . $@);
undef $@;

$object = $class->new();
$object->{_id} = '123';
eval {
    $object->can_edit();    
};
isnt($@,undef,"calling can_edit without a form throws an error: " . $@);
undef $@;

$object = $class->new();
$object->{_id} = '123';
my $form = FB::Form->new();
eval {
    $object->can_edit($form);    
};
isnt($@,undef,"calling can_edit without a saved form throws an error: " . $@);
undef $@;