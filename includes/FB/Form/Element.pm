#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element;
use strict;
use Storable qw(dclone);
use Carp;

use FB::DB;

{
  my $_count = 0;
  sub get_count        { $_count }
  sub _increment_count { ++$_count }
  
  my $class_template = "input_text.tt";
  sub get_class_template { $class_template }
  
  # Elements, by default, can be required
  sub can_be_required { return 1; }
  
  # Elements, by default, cannot be autofilled
  sub can_be_autofilled { return 0; }

# Elements, by default, can be submitted, but some can't
  # like some output elements
  sub can_be_submitted { return 1; }
  
  # Elements, by default, don't have a value stored
  # with their definition. Some, however, like output elements might.
  sub can_have_value { return 0; }

  # Elements, by default, don't have items
  # Some do, like Select and Select1
  sub can_have_items { return 0; }
  
  # Elements, by default, don't share items
  sub is_sharing_items { return 0; }
  
  # Elements, by default, don't contain other elements
  # Some do, however, like collections
  sub can_have_elements { return 0; }
  
  # Is the item custom? By default, it's not
  sub is_custom { return 0; }

  # Is label required? By default, it is
  sub is_label_required { return 1; }

  sub instructions { return ''; }
}

sub new {
    my ($class, %args) = @_; 
    my $self = {
        _id         => $args{id},
        _name       => $args{name},
        _label      => $args{label}    || "Untitled",
        _class      => $args{class}    || "input_text",
        _type       => $args{type}     || "input",
        _value      => $args{value}    || "",
        _template   => $args{template}
            || FB::Form::Element::get_class_template,
        _is_required   => 0,
        _is_required_in_collection => $args{is_required_in_collection} || 0,
        _is_autofilled => 0,
    };
    bless $self, $class;
    return $self;
}

# TODO: Error Handling (what if not form is found in the store with that ID?)

sub new_from_store {
    my $class = shift;
    my $id = shift;
    my $stored_form = FB::DB::Element->retrieve($id);
    return $class->new_from_object($stored_form);
}

# Construct a Form based on an object from the store.

sub new_from_object {
    my $class  = shift;
    my $object = shift;
    my $self   = {
        _id          => $object->id,
        _name        => $object->name,
        _label       => $object->label,
        _class       => $object->class,
        _type        => $object->type,
        _value       => $object->value,
        # These two need to be moved and incorporated into an appearance model
        _template    => $object->template,
        _is_required    => $object->is_required,
        _is_required_in_collection    => $object->is_required_in_collection,
        _is_autofilled  => $object->is_autofilled,

    };
    bless $self, $class;
    return $self;
}

#
# Accessors
#

sub id {
    my $self = shift;
    if (@_) { $self->{_id} = shift; }
    return $self->{_id};
}

sub name {
    return $_[0]->{_name};
}

sub set_name {
    $_[0]->{_name} = $_[1];
}

sub label {
    return $_[0]->{_label};
}

sub set_label {
    $_[0]->{_label} = $_[1];
}

sub class {
    return $_[0]->{_class};
}

sub set_class {
    $_[0]->{_class} = $_[1];
}

sub type {
    return $_[0]->{_type};
}

sub set_type {
    $_[0]->{_type} = $_[1];
}

sub template {
    return $_[0]->{_template};
}

sub set_template {
    $_[0]->{_template} = $_[1];
}

sub is_autofilled {
    return $_[0]->{_is_autofilled}
}

sub set_is_autofilled {
    $_[0]->{_is_autofilled} = $_[1];
}

sub is_required {
    return $_[0]->{_is_required}
}

# this particular function has a problem, I think, in that it's called using a collection ID
# elements can belong to only one collection and so, the collection ID, and the sort order
# within that collection could be just part of the element table, with those values being null
# if a particular element didn't belong in a collection - this is similar to itemset/item
sub sort_order {
    my $self = shift;
    my $collection_id = shift;
    my $connection = FB::DB::Collection_Element->retrieve(collection => $collection_id, element => $self->id );
    return $connection->sort_order;
}

sub set_sort_order {
    my $self = shift;
    my $collection_id = shift;
    my $location = shift;
    my $connection = FB::DB::Collection_Element->retrieve(collection => $collection_id, element => $self->id );
    $connection->set(sort_order => $location);
    $connection->update;
}

##############################################################################
# Usage       : $element->set_is_required(1)
# Purpose     : set the required flag
# Returns     : the new status value
# Parameters  : Either a 1 or 0
# Throws      : a warning if neither a 1 or a 0 was passed
# Comments    : This flag can only be set to 1 or 0, any other value defaults
#               to 0. We do an "eq" test instead of "==" because otherwise we
#               get false positives for strings such as 'abc'
# See Also    : n/a

sub set_is_required {
    my $self = shift;
    my $status = shift;
    if (defined $status) {
        if (($status eq 1) || ($status eq 0)) {
            $self->{_is_required} = $status;
            return $status;
        }
    }
    Carp::carp("set_is_required() not called with 1 or 0, defaulted to 0");
    $self->{_is_required} = 0;
}

sub is_required_in_collection {
    return $_[0]->{_is_required_in_collection};
}

sub set_is_required_in_collection {
    $_[0]->{_is_required_in_collection} = $_[1];
}

sub validation_profile {
    my $self = shift;
    my %validation_profile;
    if ($self->can_be_required && $self->is_required) {
        $validation_profile{'required'} = [$self->name];
    }
    else {
        $validation_profile{'optional'} = [$self->name];
    }
    return \%validation_profile;
}

sub value {
    return $_[0]->{_value};
}

sub set_value {
    $_[0]->{_value} = $_[1];
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
        my $stored_object = FB::DB::Element->retrieve($self->id);
        $stored_object->set(
            label    => $self->label,
            name     => $self->name, 
            class    => $self->class, 
            type     => $self->type, 
            value    => $self->value,
            template => $self->template,
            is_required => $self->is_required,
            is_required_in_collection => $self->is_required_in_collection,
            is_autofilled => $self->is_autofilled,
        );
        $stored_object->update;
        return $stored_object->id;
    }
    else {
        my $stored_object
            = FB::DB::Element->insert({
                label    => $self->label,
                name     => $self->name,
                class    => $self->class, 
                type     => $self->type, 
                value    => $self->value,
                template => $self->template,
                is_required => $self->is_required,
                is_required_in_collection => $self->is_required_in_collection,
                is_autofilled => $self->is_autofilled,
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
# Usage       : $node->remove_from_store
# Purpose     : remove a node from the database
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : A regular element has no children, so it just deletes itself 
# See Also    : n/a

# TODO: error handling

sub remove_from_store {
    my $self = shift;
    
    # retrieve the element to be deleted
    my $stored_object = FB::DB::Element->retrieve($self->id);

    # TODO: do we need to delete the ID in case this object is still used?

    # delete the stored version of this object
    if ($stored_object) {
        $stored_object->delete;        
    }
}



# maybe not needed

sub form {
    my $self = shift;
    if (@_) { $self->{_form} = shift; }
    return $self->{_form};
}

sub copy {
    my $self = shift;
    croak "can't copy class $self" unless ref $self;
    my $copy = Storable::dclone($self);
    
    # when we make a copy of the element we don't want to keep
    # the ID or the name or when we store it, it will overwrite
    # the original
    undef($copy->{_id});
    undef($copy->{_name});
    return $copy;
}

sub _create_identifier {
    my $self = shift;
    my $identifier = "field_" . get_count();
    $self->id($identifier);
    $self->name($identifier);
    _increment_count();
}

sub as_html {
    my $self = shift;
    my $page = shift;
    my $template
        = Template->new( { INCLUDE_PATH => $self->form->templates_path });
    my $html_output = "";
    $template->process(
        $self->template,
        { element => $self, page => $page },
        \$html_output) or die $template->error();
    return $html_output;
}

1;  # so the require or use succeeds
