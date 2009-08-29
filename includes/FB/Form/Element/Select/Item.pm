#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Select::Item;
use strict;

use FB::Form::Element;
our @ISA = qw(FB::Form::Element);

{
    our %defaults = (
        label    => "Unknown",
        value    => "Unknown",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

##############################################################################
# Usage       : $item = FB::Form::Element::Select::Item->new()
# Purpose     : Create a new item for an itemset
# Returns     : An object of type FB::Form::Element::Select::Item
# Parameters  : label, value, itemset_id, sort_order, all optional
# Throws      : no exceptions
# Comments    : An item represents an option in a select drop down menu, a
#               checkbox or a radio button. We default to using the label as
#               the value of the item.

sub new {
    my ($class, %args) = @_; 
    my $self = {
        _label      => $args{label}       || $class->defaults('label'),
        _value      => $args{value}       
            || $args{label} 
            || $class->defaults('value'),
        _itemset_id => $args{itemset_id},
        _sort_order => $args{sort_order},
    };
    bless $self, $class;  
    return $self;
}

##############################################################################
# Usage       : ????
# Purpose     : ????
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub new_from_store {
  my $class = shift;
  my $id = shift;
  # TODO: This doesn't look right, fix!
  my $stored_form = FB::DB::Element::Select::Item->retrieve($id);
  return FB::Form::Element::Select::Item->new_from_object($stored_form);
}

##############################################################################
# Usage       : ????
# Purpose     : ????
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code
# Construct an item based on an object from the store.

sub new_from_object {
    my $class  = shift;
    my $object = shift;
    my $self   = {
        _id          => $object->id,
        _label       => $object->label,
        _value       => $object->value,
        _itemset_id  => $object->itemset_id,
        _sort_order  => $object->sort_order,
    };
    bless $self, $class;
    return $self;
}


#
# Accessors
#

# There is no set_id as the ID is set when an object is
# constructed and nowhere else
sub id {
    return $_[0]->{_id};
}

sub set_itemset_id {
    my $self = shift;
    my $itemset_id = shift;
    $self->{_itemset_id} = $itemset_id;
}

sub itemset_id {
    return $_[0]->{_itemset_id};
}

##############################################################################
# Usage       : $item->set_sort_order(10)
# Purpose     : Sets the value for the sort-order
# Returns     : nothing
# Parameters  : a non-negative integer
# Throws      : carps if it's forced to ignore a parameter with non-digits
# Comments    : The sort_order of an item might be modified if the form
#               builder is asked to move items around
# See Also    : n/a

sub set_sort_order {
    my $self = shift;
    my $sort_order = shift;

    # only update the sort order if something was passed
    if (!(defined $sort_order)) {
        Carp::carp("set_sort_order called with undef value, ignored.");
        return;
    }

    # only update the sort order if something was passed
    if ($sort_order eq "") {
        Carp::carp("set_sort_order called with empty string, ignored.");
        return;
    }
    
    # only update the sort order if it has non-digits
    if ($sort_order =~ /\D/) {
        Carp::carp("set_sort_order called with non-digit value, ignored.");
        return;
    }
    else {
        $self->{_sort_order} = $sort_order;
        return;
    }
}

sub sort_order {
    return $_[0]->{_sort_order};
}

##############################################################################
# Usage       : ????
# Purpose     : ????
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub store {
    my $self = shift;
  
    # does this object have an ID?
    # If yes, update the record
    # If not, create a new record
    if (defined($self->id)) {
        my $stored_object = FB::DB::Item->retrieve($self->id);
        $stored_object->set(
            label      => $self->label, 
            value      => $self->value,
            itemset_id => $self->itemset_id,
            sort_order => $self->sort_order,
            );
        $stored_object->update;
        return $stored_object->id;
    }
    else {
        my $stored_object 
            = FB::DB::Item->insert({
                label       => $self->label, 
                value       => $self->value,
                itemset_id  => $self->itemset_id,
                sort_order  => $self->sort_order,
                });
        $self->{_id} = $stored_object->id;
        return $stored_object->id;
  }
}

##############################################################################
# Usage       : $item->remove_from_store
# Purpose     : remove a item from the database
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : A regular item has no children, so it just deletes itself 
# See Also    : n/a

# TODO: error handling

sub remove_from_store {
    my $self = shift;
    
    # retrieve the element to be deleted
    my $stored_item = FB::DB::Item->retrieve($self->id);
    
    # attempt to delete it only if there is an item there
    if ($stored_item) {
        $stored_item->delete;
    }

    # TODO: do we need to delete the ID in case this item is still used?
    # TODO: what should we return?
}

1;
