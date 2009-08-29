#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Select::Service;
use strict;

use FB::Form::Element::Select;
use FB::Form::Element::Select::ItemSet;

our @ISA = qw(FB::Form::Element::Select);

{  
    # This item is custom.
    sub is_custom { return 1; }
  
    our %defaults = (
        label    => "ITS Services",
        class    => "service",
        type     => "select_services",
        template => "select.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

sub _init {
    my $self = shift;
    my $itemset = FB::Form::Element::Select::ItemSet->new_from_store(2);
    $self->{_itemset} = $itemset;
}

1;
