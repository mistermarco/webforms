#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Collection::Name;
use strict;

use FB::Form::Collection;
use FB::Form::Element::Input;

our @ISA = qw(FB::Form::Collection);

{
    our %defaults = (
        label    => "Name",
        class    => "name",
        type     => "collection_name",
        template => "fieldset.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }

    # The name collection can be autofilled
    sub can_be_autofilled { return 1; }

    sub is_custom { return 1; }

}

sub _init {
    my $self = shift;

    $self->add_element(
        FB::Form::Element::Input->new(
            class => "name_first",
            label => "First",
            is_required_in_collection => 1,
        )
    );
  
    $self->add_element(
        FB::Form::Element::Input->new(
            class => "name_last",
            label => "Last",
            is_required_in_collection => 1,
        )
    );
}

1;
