#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';
use_ok('FB::Form::Element');

my $element = FB::Form::Element->new();
my $status;

is($element->isa("FB::Form::Element"), 1, "...has correct class");
is($element->is_required, 0, "...required is 0 by default");

$element = FB::Form::Element->new( is_required => 1 );
is($element->is_required, 0, "...required cannot be set in constructor");

$status = $element->set_is_required(1);
is($element->is_required, 1, "...setting is_required to 1 returns 1");
is($status, 1, "...setting is_required to 1 returns status 1");

$element->set_is_required(0);
$element->set_is_required('1');
is($element->is_required, 1, "...setting is_required to '1' returns 1");

$element->set_is_required(1);
$status = $element->set_is_required(0);
is($element->is_required, 0, "...setting is_required to 0 returns 0");
is($status, 0, "...setting is_required to 0 returns status 0");

$element->set_is_required(1);
$element->set_is_required('0');
is($element->is_required, 0, "...setting is_required to '0' returns 0");

$element->set_is_required(1);
$element->set_is_required();
is($element->is_required, 0, "...setting is_required to undef returns 0");

$element->set_is_required(1);
$element->set_is_required(2);
is($element->is_required, 0, "...setting is_required to 2 returns 0");

$element->set_is_required(1);
$element->set_is_required('abc');
is($element->is_required, 0, "...setting is_required to a string returns 0");

$element->set_is_required(1);
$element->set_is_required(' ');
is($element->is_required, 
    0, 
    "...setting is_required to an empty string returns 0"
);

##############################################################################
# Validation 
#

$element = FB::Form::Element->new();
$element->set_is_required(1);
$element->set_name('abc');
my $expected_validation_profile = {
    required => [ qw/abc/],
};

is_deeply($element->validation_profile, $expected_validation_profile, "valid");
##############################################################################
# 
#
