#!/usr/bin/perl
#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
use strict;
use warnings;

use lib 'includes';
use FB;

use AppConfig qw(:expand :argcount);

my $config = AppConfig->new(
    'language'           => { 
        ARGCOUNT => ARGCOUNT_ONE,
        DEFAULT => 'en_us',
    },
    'templates_path'     => {
        ARGCOUNT => ARGCOUNT_LIST,  
        DEFAULT => 'templates',
    },
    'max_forms_per_user' => { 
        ARGCOUNT => ARGCOUNT_ONE, 
        DEFAULT => 20,
    },
    'users_max_forms' => { 
        ARGCOUNT => ARGCOUNT_ONE, 
        DEFAULT => 20,
    },
    'users_can_create_new' => { 
        ARGCOUNT => ARGCOUNT_ONE, 
        DEFAULT => 1,
    },
    'users_can_create_automatically' => { 
        ARGCOUNT => ARGCOUNT_ONE, 
        DEFAULT => 1,
    },
);

$config->file('includes/config.txt');

my $fb = new FB($config);

eval {
    $fb->build();
};
if ($@) {
    $fb->display_error(error_message => $@, fatal => 1);
}
exit;
