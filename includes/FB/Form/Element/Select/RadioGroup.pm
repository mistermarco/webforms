#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Select::RadioGroup; 

use FB::Form::Element::Select;
our @ISA = qw(FB::Form::Element::Select);

{
    our %defaults = (
        label    => "Untitled",
        class    => "radio",
        type     => "select_radio",
        template => "radiogroup.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

1;
