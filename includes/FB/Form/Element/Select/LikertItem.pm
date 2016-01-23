#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Select::LikertItem; 

use FB::Form::Element::Select;
our @ISA = qw(FB::Form::Element::Select);
{

# Elements, by default, don't share items, but likertItem does
sub is_sharing_items { return 1; }

}

{
    our %defaults = (
        label    => "Question: ",
        class    => "radio",
        type     => "select_likert",
        template => "likert/item.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

sub _init {
    my $self = shift;
    $self->add_item(
        FB::Form::Element::Select::Item->new(
            label => "Strongly disagree",
            value => "Strongly disagree",
        )
    );

    $self->add_item(
        FB::Form::Element::Select::Item->new(
            label => "Disagree",
            value => "Disagree",
        )
    );

    $self->add_item(
        FB::Form::Element::Select::Item->new(
            label => "Neither agree nor disagree",
            value => "Neither agree nor disagree",
        )
    );

    $self->add_item(
        FB::Form::Element::Select::Item->new(
            label => "Agree",
            value => "Agree",
        )
    );

    $self->add_item(
        FB::Form::Element::Select::Item->new(
            label => "Strongly agree",
            value => "Strongly agree",
        )
    );
}

1;
