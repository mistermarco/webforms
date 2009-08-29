#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Collection::Address; 
use strict;
use warnings;

use FB::Form::Collection;
use FB::Form::Element::Input;
use FB::Form::Element::Select::Country;

our @ISA = qw(FB::Form::Collection);

{
    our %defaults = (
        label    => "Address",
        class    => "address",
        type     => "collection_address",
        template => "fieldset.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }

    sub is_custom { return 1; }

}

sub _init {
    my $self = shift;

    $self->add_element(
        FB::Form::Element::Input->new(
            class => "street_line1",
            label => "Street Address",
            is_required_in_collection => 1,
        )
    );

    $self->add_element(
        FB::Form::Element::Input->new(
            class => "street_line2",
            label => "Address Line 2",
            is_required_in_collection => 0,
        )
    );
    
    $self->add_element(
        FB::Form::Element::Input->new(
            class => "city",
            label => "City",
            is_required_in_collection => 1,
        )
    );

    $self->add_element(
        FB::Form::Element::Input->new(
            class => "state",
            label => "State / Province / Region",
            is_required_in_collection => 1,
        )
    );

    $self->add_element(
        FB::Form::Element::Input->new(
            class => "zip",
            label => "Postal / Zip Code",
            is_required_in_collection => 1,
        )
    );

    my $country_element = FB::Form::Element::Select::Country->new();
    $country_element->set_is_required_in_collection(1);
    $self->add_element($country_element);
}

1;
