#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Collection::Likert;
use strict;
use warnings;

use FB::Form::Collection;
use FB::Form::Element::Input;
use FB::Form::Element::Select::LikertItem;

our @ISA = qw(FB::Form::Collection);

{
    our %defaults = (
        label    => "Please answer the following questions:",
        class    => "likert",
        type     => "collection_likert",
        template => "likert.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
    
    # Likert have elements that share element values
    sub has_unique_elements { return 0; }
}

sub _init {
    my $self = shift;

    my $first_element = 
        FB::Form::Element::Select::LikertItem->new(
            class => "likert_item",
            label => "Question One: ",
            is_required_in_collection => 1,
    );

    # We store the first element's itemset so that it 
    # gets a database ID we can then use later (when copying)
    $first_element->itemset->store;

    $self->add_element($first_element);

    my $second_element = $first_element->copy();
    $second_element->set_label("Question Two: ");
    $self->add_element($second_element);

    my $third_element = $first_element->copy();
    $third_element->set_label("Question Three: ");
    $self->add_element($third_element);
    
}

1;
