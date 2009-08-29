#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';

my $class = "FB::Form::Element::Select::ItemSet";

use_ok('FB');
use_ok($class);

##############################################################################
# Test defaults
#

isnt($class->defaults('label'), undef, "Default label set for class");
isnt($class->defaults('is_custom'), undef, "Default value set for is_custom");

##############################################################################
# Test constructor
#

my $object = $class->new();
is($object->isa("$class"), 1, "Object of type $class created");

is($object->label,  $class->defaults('label'),  "...has default label");
is($object->is_custom,  $class->defaults('is_custom'),  "...has default is_custom");

isnt($object->items, undef, "...has an items array");

my @items = @{$object->items};
is(scalar @items,0,"...has an empty items array");

##############################################################################
# Test Accessors
#

$object = $class->new();
$object->{_id} = '123';
is($object->id, '123', "id works");

my $label = "new label";
$object->set_label($label);
is ($object->label, $label, "label works");

$object->set_is_custom(1);
is($object->is_custom,1,"is custom works");

$object->set_is_custom(0);
is($object->is_custom,0,"is custom works");

$object->set_is_custom(1);
$object->set_is_custom(2);
is($object->is_custom,1,"set_is_custom ignores incorrect values");

#
# items
#

$object = $class->new();
@items = @{$object->items};
is(scalar @items,0,"items works on new objects");

my $item_one = FB::Form::Element::Select::Item->new();
$object->add_item($item_one);
@items = @{$object->items};
is(scalar @items,1,"items works with one item");

my $item_two = FB::Form::Element::Select::Item->new();
$object->add_item($item_two);
@items = @{$object->items};
is(scalar @items,2,"items works with more than one item");

# deleted_items

$object = $class->new();
$object->add_item($item_one);
$object->add_item($item_two);
$object->remove_item_at(1);
my @deleted_items = @{$object->deleted_items};
is(scalar @deleted_items,0,"deleted_items shows no items if not saved");
