#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::User;
use strict;
use warnings;

use FB::DB;

{
    our %defaults = (
        max_forms   => 10,
        is_active   => 1,
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

##############################################################################
# Usage       : $user->new()
# Purpose     : ????
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking

sub new {
    my ($class, %args) = @_; 
    my $self = {
        _identifier => $args{identifier},
        _name       => $args{name},
        _email      => $args{email},
        _max_forms  => $args{max_forms} || $class->defaults('max_forms'),
        _is_active  => $args{is_active},
    };
    
    # set to default if it's not been set above
    # can's use the usual "$args{is_active} ||" syntax as the value could be 0
    if (!defined $self->{_is_active}) {
        $self->{_is_active} = $class->defaults('is_active');
    }
    
    bless $self, $class;
    return $self;
}

sub new_from_store {
    my $class = shift;
    my $identifier = shift;
    my ($stored_user)
        = FB::DB::User->search( identifier => $identifier);
    if ($stored_user) {
        return $class->new_from_object($stored_user);
    }
    else {
        return undef;
    }
}

sub new_from_store_by_id {
    my $class = shift;
    my $user_id = shift;
    my ($stored_user)
        = FB::DB::User->search( user_id => $user_id);
    if ($stored_user) {
        return $class->new_from_object($stored_user);
    }
    else {
        return undef;
    }
}

sub new_from_object {
    my $class = shift;
    my $object = shift;
    my $self = {
        _id         => $object->id,
        _identifier => $object->identifier,
        _name       => $object->name,
        _email      => $object->email,
        _max_forms  => $object->max_forms,
        _is_active  => $object->is_active,
    };
    bless $self, $class;
#    my @forms = $object->forms( role => 'creator');
    my @forms = $object->non_deleted_forms;
    $self->set_forms(\@forms);
    
    return $self;
}

sub store {
    my $self = shift;
  
    # does this object have an ID?
    # If yes, update the record
    # If not, create a new record
    if (defined($self->id)) {
        my $stored_object = FB::DB::User->retrieve($self->id);
        $stored_object->set(
            identifier  => $self->identifier,
            name        => $self->name, 
            email       => $self->email,
            max_forms   => $self->max_forms,
            is_active   => $self->is_active,
        );
        $stored_object->update;
        return $stored_object->id;
    }
    else {
        my $stored_object
            = FB::DB::User->insert({
                identifier  => $self->identifier,
                name        => $self->name, 
                email       => $self->email,
                max_forms   => $self->max_forms,
                is_active   => $self->is_active,
            });
            
        $self->id($stored_object->id);
        return $stored_object->id;
    }
}

##############################################################################
# Accessors
#

sub id {
    return $_[0]->{_id};
}

sub set_name {
    $_[0]->{_name} = $_[1];
}

sub name {
    return $_[0]->{_name};
}

sub set_email {
    $_[0]->{_email} = $_[1];
}

sub email {
    return $_[0]->{_email};
}

sub identifier {
    return $_[0]->{_identifier};
}

sub set_max_forms {
    $_[0]->{_max_forms} = $_[1];    
}

sub max_forms {
    return $_[0]->{_max_forms};
}

sub set_is_active {
    $_[0]->{_is_active} = $_[1];    
}

sub is_active {
    return $_[0]->{_is_active};
}

sub set_forms {
    $_[0]->{_forms} = $_[1];    
}

sub forms {
#    wantarray ? @{$_[0]->{_forms}} : $_[0]->{_forms};
    return $_[0]->{_forms};
}

#
# When a FB::User is first created, references to DB::FB::Form objects
# are placed into an array whose reference is placed in _forms.
# If some part of the program deletes one of those forms (by setting its
# is_deleted flag, we need to re-create this array.

# Another way would be to just poll the database for this information
# when it's needed, but we should catalog where it's used first to make sure
# we don't affect performance

sub reload_forms {
    my $self = shift;
#    my @forms = @{$self->forms};
#    my @non_deleted_forms = grep { $_->is_deleted != 1 } @forms;
#    $self->set_forms(\@non_deleted_forms);
    # TODO:
    # Is this line below that much faster? It's certainly not as clear...
    $self->set_forms([grep { $_->is_deleted != 1 } @{$self->forms}]);

}

sub remove_form {
    my $self = shift;
    my $form = shift;
    $self->set_forms([grep {$_->id != $form->id } @{$self->forms}]);
}


##############################################################################
# Usage       : $user->add_form
# Purpose     : Adds an already existing form to the user
# Returns     : A connect (FB::DB::User_Form object)
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
#   Make sure we have been passed a form
#   Make sure the form has been stored (has to have an id)
#   Make sure we have been passed a form
#   Make sure the user has been stored (has to have an id)
#   Make sure the connection worked
# TODO: Testing Code

sub add_form {
    my $self = shift;
    my $form = shift;
    my $role = shift;
    
    my $connection
        = FB::DB::User_Form->insert({
            user => $self->id,
            form => $form->id,
            role => $role,
        });

    my $form_object = FB::DB::Form->retrieve($form->id);
    push @{$self->forms}, $form_object;
    return $connection;
}

sub remove_from_admin {
  use Data::Dumper;
  use CGI;
  my $q = new CGI;
  print $q->header;
  my $self = shift;
  my $form = shift;

  my $connection
    = FB::DB::User_Form->retrieve(
	  user => $self->id,
	  form => $form->id,
	  role => 'admin',
	  );

  $connection->delete();
}

##############################################################################
# Usage       : $user->can_edit($form)
# Purpose     : Finds out if a user can edit a form
# Returns     : 1 or 0
# Parameters  : a form object
# Throws      : exceptions if a valid FB::Form was not passed
# Comments    : none
# See Also    : n/a

sub can_edit {
    my $self = shift;
    
    my $user_id = $self->id;

    # Is the user ID defined?
    if (!defined($user_id)) {
        Carp::croak("The user has no ID. Maybe it wasn't saved yet?");
    }
    
    # Is the ID blank or not numeric?
    # An ID might be blank if a form was created but not stored before
    # it was checked for permissions
    if (($user_id eq "") || ($user_id =~ /\D/)) {
        Carp::croak("The user has no ID. Maybe it wasn't saved yet?");
    }

    my $form = shift;

    # Was anything passed?
    if (!defined($form)) {
        Carp::croak("Function needs a form, but nothing was passed");
    }

    # Was a FB::Form object passed?
    if(!$form->isa("FB::Form")) {
        Carp::croak("Function needs an object of type FB::Form");
    }
    
    my $form_id = $form->id;

    # Is the form ID defined?
    if (!defined($form_id)) {
        Carp::croak("The form has no ID. Maybe it wasn't saved yet?");
    }
    
    # Is the ID blank or not numeric?
    # An ID might be blank if a form was created but not stored before
    # it was checked for permissions
    if (($form_id eq "") || ($form_id =~ /\D/)) {
        Carp::croak("The form has no ID. Maybe it wasn't saved yet?");
    }

    # Class::DBI will throw an exception if there is a problem
    my @permissions
        = FB::DB::User_Form->search( user => $user_id, form => $form_id);

    if ($#permissions >= 0) {
        return 1;
    }
    else {
        return 0;
    }
}

1; # end of module
