#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';

my $class = "FB::Form::Element::Input";

use_ok('FB');
use_ok($class);

my $object = $class->new();
is($object->isa($class), 1, "Object of class " . $class . " created.");