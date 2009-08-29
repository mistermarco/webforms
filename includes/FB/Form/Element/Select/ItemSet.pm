#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Select::ItemSet;
use strict;

use FB::Form::Element;
use FB::Form::Element::Select::Item;
use FB::Validation qw(is_1_or_0);

our @ISA = qw(FB::Form::Element);

{
    our %defaults = (
        label    => "None",
        is_custom => 0,
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

##############################################################################
# Usage       : FB::Form::Element::Select::Itemset->new()
# Purpose     : Creates a new ItemSet object
# Returns     : An object of class FB::Form::Element::Select::ItemSet
# Parameters  : none
# Throws      : no exceptions
# Comments    : An ItemSet is contained within a Select Item. There is usually
#               only one itemset per select. The itemset is an optiongroup and
#               the items it contains are options
# See Also    : n/a

sub new {
    my ($class, %args) = @_; 
    my $self = {
        _label         => $args{label}     || $class->defaults('label'),
        _is_custom     => $args{is_custom} || $class->defaults('is_custom'),
        _items         => [],
        _deleted_items => [],
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
    my $stored_itemset = FB::DB::ItemSet->retrieve($id);
    return $class->new_from_object($stored_itemset);
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
# Construct an ItemSet based on an object retrieved from the store

sub new_from_object {
    my $class  = shift;
    my $object = shift;
    my $self   = {
        _id             => $object->id,
        _label          => $object->label,
        _is_custom      => $object->is_custom,
        _items          => [],
        _deleted_items  => [],
    };
    bless $self, $class;
    
    # Load the items from the database
    foreach my $stored_item ($object->items) {
        # construct an Item object using the data from the database
        my $new_item = FB::Form::Element::Select::Item->new_from_object($stored_item);
        # add this item to the list of items
        $self->add_item($new_item);
    }
    return $self;
}

##############################################################################
# Accessors
# 

# there is no set_id, as we only set the id when we retrieve from the database
sub id {
    return $_[0]->{_id};
}

sub is_custom {
    return $_[0]->{_is_custom};
}

sub set_is_custom {
    my $self = shift;
    my $new_status = shift;
    if (is_1_or_0($new_status)) {
        $self->{_is_custom} = $new_status;        
    }
}

# there is no set_items as items are added one by one using add_item,
# add_item_at or during an object's construction from the database
sub items {
    return $_[0]->{_items};
}

# there is no set_deleted_items as items are removed one by one
sub deleted_items {
    return $_[0]->{_deleted_items};
}

##############################################################################
# Usage       : $itemset->add_item($item)
# Purpose     : Add an existing item to the itemset
# Returns     : ????
# Parameters  : Takes a reference to an item of type Element::Select::Item
# Throws      : no exceptions
# Comments    : none
# See Also    : add_item_from_store

# TODO: Error checking

sub add_item {
    my $self   = shift;    
    my $item = shift;
    push (@{$self->{_items}}, $item);
}

##############################################################################
# Usage       : $itemset->add_item_at($item, $location)
# Purpose     : Add item to the itemset at the location specified
# Returns     : ????
# Parameters  : Takes a reference to an item of type Element::Select::Item
#               and a 0-based location
# Throws      : no exceptions
# Comments    : none
# See Also    : add_item

# TODO: error checking

sub add_item_at {
    my $self  = shift;    
    my $item = shift;
    my $location = shift;
    splice(@{$self->{_items}}, $location, 0, $item);
}

##############################################################################
# Usage       : $itemset->get_item_at($location)
# Purpose     : Get the item at the location specified
# Returns     : An item
# Parameters  : Takes a 0-based location
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: error checking

sub get_item_at {
    my $self  = shift;
    my $location = shift;
    return @{$self->{_items}}[$location];
}

##############################################################################
# Usage       : $itemset->move_item_up(2);
# Purpose     : Move the item at the location specified up one
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : index is 0-based
# See Also    : n/a

sub move_item_up {
    my $self  = shift;
    
    return 1 if $self->{_is_custom};
    
    my $current_location = shift;
    
    # Can't move the item up if it's at the top
    return if $current_location == 0;
    
    my $new_location     = $current_location - 1;

    # check that current location is within number of items
    my @items = @{$self->items};
    return if ($#items < $current_location);

    my $item_to_move = splice(@{$self->{_items}}, $current_location, 1);
    splice(@{$self->{_items}}, $new_location, 0, $item_to_move);
    
    return $item_to_move;
}

##############################################################################
# Usage       : $itemset->move_item_down(2);
# Purpose     : Move the item at the location specified down
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : index is 0-based
# See Also    : n/a

sub move_item_down {
    my $self  = shift;
    
    return 1 if $self->{_is_custom};
    
    my $current_location = shift;
    my $new_location     = $current_location + 1;
 
    # check that the new location is within number of items
    my @items = @{$self->items};
    return if ($#items < $new_location);

    my $item_to_move = splice(@{$self->{_items}}, $current_location, 1);
    splice(@{$self->{_items}}, $new_location, 0, $item_to_move);
}

##############################################################################
# Usage       : $itemset->remove_item_at($item, $location)
# Purpose     : Remove the item at the specified location (0-based)
# Returns     : the removed item
# Parameters  : Takes a 0-based location
# Throws      : no exceptions
# Comments    : The item is not removed from the database (if it exists there)
#               it's stored in the array _deleted_items and deleted only when
#               ->store() is called on this itemset
#               We could delete it right away, but this way we are more
#               consistent with the add and move functions (which don't
#               affect the database) and we leave our options open for undo
# See Also    : n/a

# TODO: error checking

sub remove_item_at {
    my $self  = shift;
    
    return 1 if $self->{_is_custom};
    
    my $location = shift;
    my $removed_item = splice(@{$self->{_items}}, $location, 1);
      
    # if this item exists in the database (has an ID), we add it to the list
    # of deleted items so it can be purged from the database later
    if ($removed_item->id) {
        push (@{$self->{_deleted_items}}, $removed_item);      
    }
    
    # update all the item sort order
    if ($self->items) {
        my @items = @{$self->items};
        for (my $i = 0; $i <= $#items; $i++) {
            $items[$i]->set_sort_order($i);
        }         
    }
    
    return $removed_item;
}

##############################################################################
# Usage       : $itemset->resort_items()
# Purpose     : Resort the items based on their sort_order
# Returns     : nothing
# Parameters  : none
# Throws      : no exceptions
# Comments    : We check to see if this itemset is custom and return if none
# See Also    : n/a

# TODO: error checking

sub resort_items {
    my $self = shift;
    
    # do nothing if this itemset is custom
    return 1 if $self->{_is_custom};
    
    my @items = @{$self->items};
    @items = sort { $a->sort_order <=> $b->sort_order } reverse @items;
    $self->{_items} = \@items;
}

##############################################################################
# Usage       : $itemset->store()
# Purpose     : stores all information in the database
# Returns     : the stored itemset's id
# Parameters  : none
# Throws      : no exceptions
# Comments    : We check to see if this itemset is custom and return if none
# See Also    : n/a

# TODO: error checking

sub store {
    my $self = shift;
    
    # do nothing if this itemset is custom
    return 1 if $self->{_is_custom};
    
    # does this object have an ID?
    # If yes, update the record
    # If not, create a new record

    # TODO: any updates needed to items?
    if (defined($self->id)) {
        # retrieve the stored itemset from the database
        my $stored_itemset = FB::DB::ItemSet->retrieve($self->id);
        
        # update the only thing we allow to change, the label
        $stored_itemset->set( label => $self->label, );
        
        # update the object
        $stored_itemset->update;
        
        # update all the items
        if ($self->items) {
            my @items = @{$self->items};
            for (my $i = 0; $i <= $#items; $i++) {
                $items[$i]->set_itemset_id($stored_itemset->itemset_id);
                $items[$i]->set_sort_order($i);
                $items[$i]->store;
            }         
        }
        
        # delete any items that need to be deleted
        if ($self->deleted_items) {
            my @items = @{$self->deleted_items};
            for (my $i = 0; $i <= $#items; $i++) {
                $items[$i]->remove_from_store();
            }            
        }
        return $stored_itemset->id;
    }
    else {
        my $new_stored_itemset
            = FB::DB::ItemSet->insert({
                label     => $self->label,
                is_custom => $self->is_custom,
            });

        # if there are items, we store them too.
        if ($self->items) {
            my @items = @{$self->items};
            for (my $i = 0; $i <= $#items; $i++) {
                $items[$i]->set_itemset_id($new_stored_itemset->id);
                $items[$i]->set_sort_order($i);
                $items[$i]->store;
            }
        }
        $self->{_id} = $new_stored_itemset->id;
        return $new_stored_itemset->id;
    }
}

##############################################################################
# Usage       : $itemset->remove_from_store
# Purpose     : remove a item from the database
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : The select using this itemset is responsible for setting its
#               itemset property to undef after the asking for the itemset
#               to be deleted 
# See Also    : n/a

# TODO: error handling
#   shouldn't call this if there is no _id
#   item with supplied ID is not found

sub remove_from_store {
    my $self = shift;

    # do nothing if this itemset is custom
    return 1 if $self->{_is_custom};
    
    # retrieve the itemset from the database
    my $stored_itemset = FB::DB::ItemSet->retrieve($self->{_id});
    
    # count elements using this itemset
    my $elements_using_itemset = FB::DB::ItemSet->count_elements($self->{_id});
    
    # attempt to delete only if the item was found
    if (defined($stored_itemset) && ($elements_using_itemset == 0)) {
        $stored_itemset->items->delete_all();
        $stored_itemset->delete;
    }
    
    undef $self->{_id};
    # TODO: what should we return?
}

1;
