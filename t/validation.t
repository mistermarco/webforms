#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';
use_ok('FB::Validation');
use FB::Validation qw(is_id_ok is_1_or_0 trim);

##############################################################################
# is_id_ok
#

my %id_tests = (
    undef => 0,
    '-1'    => 0,
    '1'     => 1,
    'abc'   => 0,
    '1,000' => 0,
    ' 1'    => 0,
    '1 '    => 0,
    '01'    => 1,
    '0'     => 1,
);

foreach (keys %id_tests) {
    is(is_id_ok($_),$id_tests{$_},"is_id_ok: testing with '$_'");
}


##############################################################################
# trim
#

my %trim_tests = (
    'abc' => 'abc',
    ' abc' => 'abc',
    '  abc' => 'abc',
    'abc ' => 'abc',
    '  abc' => 'abc',
    ' abc ' => 'abc',
    '  abc  ' => 'abc',
    'abc
    '   => 'abc',
    '
    abc' => 'abc',
    "\tabc" => 'abc',
    "\t\tabc" => 'abc',
    "\tabc\t" => 'abc',
    "abc\t\t" => 'abc',
);

foreach (keys %trim_tests) {
    is(trim($_),$trim_tests{$_},"trim: testing with '$_'");
}

##############################################################################
# is_1_or_0
#

my %is_1_or_0_tests = (
    1   => 1,
    0   => 1,
    2   => 0,
    '-1'  => 0,
    '01'  => 0,
    '00'  => 0,
    'abc' => 0,
    ' '   => 0,
    undef => 0,
);

foreach (keys %is_1_or_0_tests) {
    is(is_1_or_0($_),$is_1_or_0_tests{$_},"is_1_or_0: testing with '$_'");
}