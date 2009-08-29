#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';

my $class = "FB::Form::Element::Select::Item";

use_ok('FB');
use_ok($class);

#
# Test defaults
#

isnt($class->defaults('label'), undef, "Default label set for class");
isnt($class->defaults('value'), undef, "Default value set for class");

#
# Test constructor
#

my $object = $class->new();
is($object->isa("$class"), 1, "Object of type $class created");

is($object->label,  $class->defaults('label'),  "...has default label");
is($object->value,  $class->defaults('value'),  "...has default value");
is($object->value,  $object->label,     "...has the same value and label");

is($object->itemset_id, undef, "...has undef itemset_id");
is($object->itemset_id, undef, "...has undef sort_order");

$object = $class->new(id => '123');
is($object->id, undef, "...id values are ignored by constructor");

$object->{_id} = '123';
is($object->id, '123', "...id() works");

#
# Testing set_sort_order
#

$object = $class->new();
$object->{_sort_order} = 123;
$object->set_sort_order('a');
is($object->sort_order,123,"set_sort_order ignores non-numbers");

$object = $class->new();
$object->{_sort_order} = 123;
$object->set_sort_order(' ');
is($object->sort_order,123,"set_sort_order ignores spaces");

$object = $class->new();
$object->{_sort_order} = 123;
$object->set_sort_order();
is($object->sort_order,123,"set_sort_order ignores undef");

$object = $class->new();
$object->{_sort_order} = 123;
$object->set_sort_order("");
is($object->sort_order,123,"set_sort_order ignores empty strings");
