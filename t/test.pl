#!/usr/bin/perl
use strict;

use CGI;
my $q = new CGI;
print $q->header("text/plain");

use Test::Harness;
$Test::Harness::verbose = 1;

my @tests = ();
push @tests, qw(
    db.t
    form.t
    user.t
    element.t
    element/select/item.t
    collection.t
    collection/address.t
    collection/name.t
    element/input.t
    element/input/phone.t
    element/input/email.t
    validation.t
);
runtests(@tests);
