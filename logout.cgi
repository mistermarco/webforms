#!/usr/bin/perl
#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
use CGI;
use CGI::Cookie;
my $q = new CGI;

my $cookie = CGI::Cookie->new( -name    => 'webauth_at',
                               -expires => '-1d',
                             );

print $q->header( -cookie => $cookie, -location => "https://weblogin.stanford.edu/logout");
