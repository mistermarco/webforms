#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Output::SectionHeader;
use strict;

use FB::Form::Element::Output;
our @ISA = qw(FB::Form::Element::Output);

{
    our %defaults = (
        label    => "Untitled Section",
        class    => "",
        value    => "Describe Section Here",
        type     => "output_section_header",
        template => "section_header.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

1;
