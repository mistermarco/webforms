#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';
use_ok('FB::Form::Collection::Address');

my $object = FB::Form::Collection::Address->new();

print "Address Collection has...\n";
is(
    $object->isa("FB::Form::Collection::Address"), 
    1,
    "...right class"
);

my @properties = qw/label class type template/;
foreach my $property (@properties) {
    is(
        $object->$property,
        FB::Form::Collection::Address->defaults($property),
        "...right default $property"
    );
}

my $new_label = "New Label";
$object->set_label($new_label);
is($object->label, $new_label, "set_label works");

my $new_class = "new_css_class";
$object->set_class($new_class);
is($object->class, $new_class, "set_class works");

my $new_type = "new_type";
$object->set_type($new_type);
is(
    $object->type,
    FB::Form::Collection::Address->defaults('type'),
    "set_type doesn't change type"
);

my $new_template = "new_template";
$object->set_template($new_template);
is($object->template, $new_template, "set_template works");