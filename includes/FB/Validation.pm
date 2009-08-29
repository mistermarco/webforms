#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Validation;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(is_id_ok is_1_or_0 trim);

sub is_id_ok {
    my $id = shift;
    
    # Is the ID defined?
    if (!defined($id)) {
        return 0;
    }
    
    # Is the ID blank or not numeric?
    if (($id eq "") || ($id =~ /\D/)) {
        return 0;
    }
    
    return 1;
}

sub is_1_or_0 {
    my $value = shift;
    
    # is it defined?
    if (!(defined $value)) {
        return 0;
    }

    # is it empty?
    if ($value eq "") {
        return 0;
    }
    
    # does it have non-digits?
    if ($value =~ /\D/) {
        return 0;
    }
    
    if (($value ne "1") && ($value ne "0")) {
        return 0;
    }
    
    return 1;
}

sub trim {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

1;
