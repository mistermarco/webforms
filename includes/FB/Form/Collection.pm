#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Collection; 
use strict;

use FB::Form::Element;
our @ISA = qw(FB::Form::Element);

{
    our %defaults = (
        label    => "Fieldset",
        class    => "",
        type     => "collection",
        template => "fieldset.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
    
    # Elements, by default, don't contain other elements
    # Some do, however, like collections
    sub can_have_elements { return 1; }

    # By default collections are not custom and can be updated
    sub is_custom { return 0; }
    
    # By default, collections have unique elements
    # Some collections don't, and their elements share values
    sub has_unique_elements { return 1; }
}

sub new {
    my ($class, %args) = @_;
    my $self = {
        _label    => $args{label}    || $class->defaults('label'),
        _class    => $args{class}    || $class->defaults('class'),
        
        # type is always the default and can't be changed
        _type     => $class->defaults('type'),
        _template => $args{template} || $class->defaults('template'),
        _name     => $args{name},
        _added_elements => [],
        _deleted_elements => [],
		_elements => [],
        _is_required => 0,
        _is_autofilled => 0,
    };
    bless $self, $class;
    $self->_init(@_);
    return $self;
}


# No initialization for the basic collection class
sub _init {
    return;
}

sub added_elements {
    return $_[0]->{_added_elements};
}

# there is no set_deleted_elements as elements are removed one by one
sub deleted_elements {
    return $_[0]->{_deleted_elements};
}

# Override setting the type. This shouldn't be changed after a collection
# has been created.

sub set_type {
    Carp::carp("set_type called on a collection. Ignored.");
    return;
}

# TODO: Error Handling (what if not form is found in the store with that ID?)

sub new_from_store {
    my $class = shift;
    my $id = shift;
    my $stored_object = FB::DB::Collection->retrieve($id);
    return $class->new_from_object($stored_object);
}

# Construct a Form based on an object from the store.

sub new_from_object {
    my $class  = shift;
    my $object = shift;
    my $self   = {
        _id          => $object->id,
        _label       => $object->label,
        _class       => $object->class,
        _name        => $object->name,
        _type        => $object->type,
        _added_elements => [],
        _deleted_elements => [],
		    _elements => [],
        # These two need to be moved and incorporated into an appearance model
        _template    => $object->template,
        _is_required    => $object->is_required,
        _is_autofilled  => $object->is_autofilled,
    };
    bless $self, $class;

    my @elements = $object->elements;
    foreach my $element (@elements) {
        my $element_type = $element->type;
        my $class = FB->get_class_from_type($element_type);
        $self->add_element($class->new_from_store($element->id));
    }
    return $self;  
}

#
# Storage
#

sub store {
    my $self = shift;
    my $clone = shift;
    if (!defined($clone)) { $clone = 0; }
        
    # does this object have an ID?
    # If yes, update the record
    # If not, create a new record
    if ((defined($self->id)) && ($clone == 0)) {
        my $stored_object = FB::DB::Collection->retrieve($self->id);
        $stored_object->set(
            label       => $self->label, 
            class       => $self->class,
            type        => $self->type,
            name        => $self->name,
            template    => $self->template,
            is_required => $self->is_required,
            is_autofilled => $self->is_autofilled,
        );
        $stored_object->update;
        
        # If there are elements in this collection, ask each in turn to
        # update/store itself.
        if ($self->elements) {
            my @elements = @{$self->elements};
            
            for (my $i = 0; $i <= $#elements; $i++) {

              # pass the is_required flag to the children
              if (($self->is_required) && ($elements[$i]->is_required_in_collection)) {
                $elements[$i]->set_is_required(1);
			  } else {
                $elements[$i]->set_is_required(0);
			  }


                # Ask the element to update itself
                my $element_id = $elements[$i]->store;
                
                # Find or create the connection between this collection
                # and the element.
                my $connection = FB::DB::Collection_Element->find_or_create(
                    collection => $stored_object->id,
                    element => $element_id,
                );
                
                $connection->set(sort_order => $i);
                $connection->update;
            }
        }
        
        # delete any elements that need to be deleted
        if ($self->deleted_elements) {
            my @elements = @{$self->deleted_elements};
            for (my $i = 0; $i <= $#elements; $i++) {
                # delete the connection
                my $connection = FB::DB::Collection_Element->retrieve(
                    collection => $stored_object->id,
                    element => $elements[$i]->id,
                );
                $connection->delete();
                $elements[$i]->remove_from_store();
            }            
        }
        return $stored_object->id;
    }
    else {
        my $stored_object
            = FB::DB::Collection->insert({
                label       => $self->label,
                class       => $self->class,
                type        => $self->type,
                name        => $self->name,
                template    => $self->template,
                is_required => $self->is_required,
                is_autofilled => $self->is_autofilled,
            });

        $stored_object->set( name => "collection_" . $stored_object->id);
        $stored_object->update;

        # If there are elements in this collection, ask each in turn to
        # update/store itself.
        if ($self->elements) {
            my @elements = @{$self->elements};

            # elements share itemsets by default
            # an itemset is a set of items such as answers to a survey
            # or options in a drop-down list (not shared in this case)
            # we find the itemset of the first element and we store it
            # for future use, should we need to add it to more elements
            my $new_itemset;
            if ($elements[0]->can_have_items) {
                
                # keep track of the first element's itemset
                my $itemset = $elements[0]->itemset;
                
                # if there is an itemset, store it. If it's to be cloned,
                # we'll have a new itemset, if not, we'll just get the same one back
                if ($itemset) {
                    my $new_itemset_id = $itemset->store($clone);
                    $new_itemset = FB::Form::Element::Select::ItemSet->new_from_store($new_itemset_id);                    
                }
            }
            
            for (my $i = 0; $i <= $#elements; $i++) {

                # if the element supports items and actually has an itemset,
                # set this as the itemset for all elements
                if ($elements[$i]->can_have_items && $new_itemset) {
                    $elements[$i]->set_itemset($new_itemset);                    
                }
                
                # Ask the element to update itself
                my $element_id = $elements[$i]->store($clone);
                
                # Find or create the connection between this collection
                # and the element.
                FB::DB::Collection_Element->find_or_create(
                    collection => $stored_object->id,
                    element => $element_id,
                    sort_order => $i
                );
            }
        }

        $self->id($stored_object->id);
        return $stored_object->id;
    }
}

##############################################################################
# Usage       : $node->remove_from_store
# Purpose     : remove a node (collection) and its children from the database
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : This method overrides Element's so that it can delete any
#               child Elements found under this collection
# See Also    : n/a

# TODO: error handling - what if the collection has not been stored yet?

sub remove_from_store {
    my $self = shift;
    my $stored_object = FB::DB::Collection->retrieve($self->id);

    # TODO: if we add the elements to the list of fields in the form
    # we need to remove them.
    if ($stored_object) {
        foreach (@{$self->elements}) {
            $_->remove_from_store();
        }
        #$stored_object->elements->delete_all();  
        $stored_object->delete;        
    }
}

sub form {
    my $self = shift;
    if (@_) {
        my $form = shift;
        $self->{_form} = $form;
        if ($self->elements) {
            foreach (@{$self->elements}) {
                $_->form($form);
            }
        }
    }
    return $self->{_form};
}

sub elements {
    wantarray ? @{$_[0]->{_elements}} : $_[0]->{_elements};
}

#sub element_names {
#    my $self = shift;
#    my @element_names = ();
#    if ($self->isa("FB::Form::Collection::CheckBoxGroup")
#        ||  $self->isa("FB::Form::Collection::RadioGroup")) {
#        push (@element_names, $self->name);
#    }
#    else {
#        foreach my $element (@{$self->elements}) {
#            push (@element_names, $element->name);
#        }
#    }
#    return @element_names;
#}

##############################################################################
# Usage       : $collection->get_element_at($location)
# Purpose     : Get the element at the location specified
# Returns     : An element
# Parameters  : Takes a 0-based location
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

sub get_element_at {
    my $self  = shift;
    my $location = shift;
    return @{$self->{_elements}}[$location];
}

sub add_element {
    my $self  = shift;
    my $element = shift;

    # set the element's form to the same form as the collection
    $element->form($self->form);
    
    #TODO: verify that this block is still needed.
    if ( $self->isa("FB::Form::Collection::RadioGroup")
        ||  $self->isa("FB::Form::Collection::CheckBoxGroup")) {
        $element->name($self->name);
    }
    unless ($element->id) {
        push (@{$self->{_added_elements}}, $element);
    }
    push (@{$self->{_elements}}, $element);
}

sub add_element_at {
    my $self  = shift;
    my $element = shift;
    my $location = shift;
    $element->form($self->form);
    
    #TODO: verify that this block is still needed.
    if ( $self->isa("FB::Form::Collection::RadioGroup")
        || $self->isa("FB::Form::Collection::CheckBoxGroup")) {
        $element->name($self->name);
    }
    
    unless ($element->id) {
        push (@{$self->{_added_elements}}, $element);
    }
    splice(@{$self->{_elements}}, $location, 0, $element);
}

sub remove_element_at {
    my $self  = shift;
    
    return 1 if $self->{_is_custom};
    
    my $location = shift;
    my $removed_element = splice(@{$self->{_elements}}, $location, 1);
    
    # if this element exists in the database (has an ID), we add it to the list
    # of deleted elements so it can be purged from the database later
    if ($removed_element->id) {
        push (@{$self->{_deleted_elements}}, $removed_element);      
    }
    
    # update all the elements sort order
    if ($self->elements) {
        my @elements = @{$self->elements};
        for (my $i = 0; $i <= $#elements; $i++) {
            $elements[$i]->set_sort_order($self->id, $i);
        }         
    }
    
    return $removed_element;
}

##############################################################################
# Usage       : $collection->resort_elements()
# Purpose     : Resort the elements based on their sort_order
# Returns     : nothing
# Parameters  : none
# Throws      : no exceptions
# Comments    : We check to see if this collection is custom and return
#               if is
# See Also    : n/a

# TODO: error checking

sub resort_elements {
    my $self = shift;
    
    # do nothing if this collection is custom
    return 1 if $self->{_is_custom};
    
    my @elements = @{$self->elements};
    @elements = sort { $a->sort_order($self->id) <=> $b->sort_order($self->id) } reverse @elements;
    $self->{_elements} = \@elements;
}

##############################################################################
# Usage       : $self->validation_profile
# Purpose     : Create a validation profile for the entire collection
# Returns     : A Data::FormValidator validation profile
# Parameters  : none
# Throws      : no exceptions
# Comments    : The validation profile pushes together all the requirements
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code
# TODO: This function needs to be expanded by pulling the individual element's
#       validation profiles. Suppose an email element was part of a collection
#       this routine would only make it required, but would not pass the
#       information about the email's other validation up the chain

sub validation_profile {
    my $self = shift;
    my %validation_profile;
    my @all_elements;
    my @required_elements;
    my $number_of_required_elements = 0;
    
    foreach my $element (@{$self->elements}) {
        push (@all_elements, $element->name);
        if ($self->can_be_required && $self->is_required) {
            if ($element->is_required_in_collection) {
                push (@required_elements, $element->name);
                $number_of_required_elements++;
            }
        }        
    }
    $validation_profile{'require_some'}
        = { "collection_" . $self->id
            => [$number_of_required_elements, @required_elements]};

    # This may seem weird... but elements are optional on their own
    # although required as a group.
    $validation_profile{'optional'} = \@all_elements;
    return \%validation_profile;
}

1;
