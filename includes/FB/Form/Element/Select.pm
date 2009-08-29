#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Select;
use strict;

use FB::Form::Element;
our @ISA = qw(FB::Form::Element);

{
    # Elements, by default, don't have items
    # Some do, like Select and Select1
    sub can_have_items { return 1; }
    
    our %defaults = (
        label    => "Untitled",
        class    => "",
        type     => "select",
        template => "select.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

sub new {
    my ($class, %args) = @_;
    my $self = {
        _label    => $args{label}    || $class->defaults('label'),
        _name     => $args{name},        
        _class    => $args{class}    || $class->defaults('class'),
        _type     => $args{type}     || $class->defaults('type'),
        _template => $args{template} || $class->defaults('template'),
        _itemset  => FB::Form::Element::Select::ItemSet->new(),
        _is_required => 0,
        _is_required_in_collection => $args{is_required_in_collection} || 0,
    };
    bless $self, $class;
    $self->_init(@_);
    return $self;
}

sub _init {
    my $self = shift;
    $self->add_item(
        FB::Form::Element::Select::Item->new(
            label => "First Option",
            value => "First Option",
        )
    );

    $self->add_item(
        FB::Form::Element::Select::Item->new(
            label => "Second Option",
            value => "Second Option",
        )
    );
  
    $self->add_item(
        FB::Form::Element::Select::Item->new(
            label => "Third Option",
            value => "Third Option",
        )
    );
}

# TODO: Error Handling

sub new_from_store {
  my $class = shift;
  my $id = shift;
  my $stored_object = FB::DB::Element->retrieve($id);
  return $class->new_from_object($stored_object);
}

# Construct a Select based on an object from the store.

sub new_from_object {
    my $class  = shift;
    my $object = shift;
    my $self   = {
        _id       => $object->id,
        _name     => $object->name,
        _label    => $object->label,
        _class    => $object->class,
        _type     => $object->type,
        _value    => $object->value,
        _template => $object->template,
        _is_required => $object->is_required,
        _is_required_in_collection => $object->is_required_in_collection,
    };
    bless $self, $class;
    
    # Load the itemset if one exists, or create a new empty one
    if ($object->itemset) {
        my $itemset = FB::Form::Element::Select::ItemSet->new_from_object($object->itemset);
        $self->{_itemset} = $itemset;
    }
    else {
        my $itemset = FB::Form::Element::Select::ItemSet->new($self->{_label});
        $self->{_itemset} = $itemset;
    }

    return $self;
}

##############################################################################
# Accessors

sub itemset {
    my $self = shift;
    return $self->{_itemset};
}

sub set_itemset {
	my $self = shift;
	my $itemset = shift;
	$self->{_itemset} = $itemset;
}

##############################################################################
# Defer all item operations to the itemset
# We do this now, which seems odd, so that in the future we can make use of
# more than one itemset (usually handled by forms as optgroups)

sub items {
    my $self = shift;
    return $self->itemset->items();
}

sub add_item {
    my $self   = shift;
    my $item = shift;
    return $self->itemset->add_item($item);
}

sub get_item_at {
    my $self  = shift;
    my $location = shift;
    return $self->itemset->get_item_at($location);
}

sub add_item_at {
    my $self  = shift;
    my $item = shift;
    my $location = shift;
    return $self->itemset->add_item_at($item, $location);
}

sub remove_item_at {
    my $self  = shift;
    my $location = shift;
    return $self->itemset->remove_item_at($location);
}

sub move_item_up {
    my $self  = shift;
    my $current_location = shift;
    return $self->itemset->move_item_up($current_location);
}

sub move_item_down {
    my $self  = shift;
    my $current_location = shift;
    return $self->itemset->move_item_down($current_location);
}

sub resort_items {
    my $self  = shift;
    return $self->itemset->resort_items;
}

##############################################################################
# Usage       : $select->store()
# Purpose     : Store the select element in the database, ask the itemset
#               to store itself
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : none

# TODO: Error checking

sub store {
    my $self = shift;
  
    # does this object have an ID?
    # If yes, update the record
    # If not, create a new record
    
    # first, store the itemset as we'll need its ID
    $self->itemset->store();
    my $itemset_id = $self->itemset->id();
  
    # TODO: any updates needed to items?
    if (defined($self->id)) {
        my $stored_select = FB::DB::Element->retrieve($self->id);
        $stored_select->set(
            label    => $self->label,
            name     => $self->name,
            class    => $self->class, 
            type     => $self->type,
            value    => $self->value,
            template => $self->template,
            itemset  => $itemset_id,
            is_required => $self->is_required,
            is_required_in_collection => $self->is_required_in_collection,
        );
        
        # write the updates to the database
        $stored_select->update;
        return $stored_select->id;
    }
    else {
        my $stored_object
            = FB::DB::Element->insert({
                label    => $self->label,
                class    => $self->class, 
                type     => $self->type,
                value    => $self->value,
                template => $self->template,
                itemset  => $itemset_id,
                is_required => $self->is_required,
                is_required_in_collection => $self->is_required_in_collection,                
            });
            
        my $new_id = $stored_object->id;

        $stored_object->set( name => "field_$new_id" );
        $stored_object->update;

        $self->set_name("field_$new_id");
        $self->id($new_id);
            
        return $new_id;
    }
}

##############################################################################
# Usage       : $select->remove_from_store
# Purpose     : remove a select node from the database, ask its itemset
#               to remove itself
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : We override this function here because we need to clear the
#               items that only select and select1 elements have
# See Also    : n/a

# TODO: error handling

sub remove_from_store {
    my $self = shift;
    
    my $stored_object = FB::DB::Element->retrieve($self->id);
    
    if ($stored_object) {
        $stored_object->delete;        
    }
    
    # ask the itemset to delete itself
    $self->itemset->remove_from_store;
}

1;
