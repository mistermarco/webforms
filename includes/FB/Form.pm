#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form;

use strict;
use warnings;

use FB::DB;  # for storage
use FB::Theme::Plain; # default theme

# TODO: These defaults should come from config.txt and be passed to the form
# by the Form Builder

{
    our %defaults = (
        name                        => "Untitled Form",
        description                 => "Please enter a short introduction.",
        template                    => "simple_form.tt",
        css                         => "simple",
        theme                       => FB::Theme::Plain->new(),
        confirmation_method         => "text",
        confirmation_text           => "Thank you for filling out the form!",
        confirmation_url            => "",
        submission_method           => "email",
        submission_email            => "",
        submission_email_subject    => "Form Submission",
    );

    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

##############################################################################
# Usage       : $form = FB::Form->new()
#               $form = FB::Form->new( name => "abc", path => "/home", etc.)
# Purpose     : Creates a new form object
# Returns     : A FB::Form object
# Parameters  : Can take no parameters, or some initial values
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

sub new {
    my ($class, %args) = @_;
    my $self = {
        _id                  => exists $args{id}   ? $args{id}   : undef,
        _is_live             => 0,
        _is_deleted          => 0,
        _nodes               => [],
        _added_nodes         => [],
        _updated_nodes       => [],
        _deleted_nodes       => [],
        _path                => exists $args{path} ? $args{path} : undef,
        _url                 => exists $args{url} ? $args{url} : undef,
        _name                => exists $args{name} ? $args{name} : $class->defaults('name'),
        _description         => $args{description}
            || $class->defaults('description'),
        _theme               => $args{theme}
            || $class->defaults('theme'),
        # These two need to be moved and incorporated into an appearance model
        _template            => $args{template}
            || $class->defaults('template'),
        _css                 => $args{css}         || $class->defaults('css'),
        _confirmation_method => $args{confirmation_method}
            || $class->defaults('confirmation_method'),
        _confirmation_text   => $args{confirmation_text}
            || $class->defaults('confirmation_text'),
        _confirmation_url    => $args{confirmation_url}
            || $class->defaults('confirmation_url'),
        _submission_method   => $args{submission_method}
            || $class->defaults('submission_method'),
        _submission_email    => $args{submission_email}
            || $class->defaults('submission_email'),
        _submission_email_subject    => $args{submission_email_subject}
            || $class->defaults('submission_email_subject'),
        _creator             => $args{creator},
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

# TODO: Error Handling (what if not form is found in the store with that ID?)
# TODO: Testing Code

sub new_from_store {
    my $class = shift;
    my $id = shift;
    my $stored_form = FB::DB::Form->retrieve($id);
    Carp::croak("No form with id $id was found.") unless $stored_form;
    return FB::Form->new_from_object($stored_form);
}


##############################################################################
# Usage       : ????
# Purpose     : ????
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Handling (what if not form is found with that path?)
# TODO: Testing Code

sub new_from_path {
    my $class = shift;
    my $path = shift;
    my @forms = FB::DB::Form->search(path => $path, is_deleted => 0);
	return unless defined($forms[0]);
    return FB::Form->new_from_object($forms[0]);
}

##############################################################################
# Usage       : $form = FB::Form->new_from_object($database_id)
# Purpose     : Construct a FB::Form object from a DB Object
# Returns     : A FB::Form Object
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub new_from_object {
    my $class  = shift;
    my $object = shift;
    my $self   = {
        _id                  => $object->id,
        _path                => $object->path,
        _url                 => $object->url,
        _name                => $object->name,
        _description         => $object->description,
        _is_live             => $object->is_live,
        _is_deleted          => $object->is_deleted,
        _template            => $object->template,
        _css                 => $object->css,
        _date_created        => $object->date_created,
        _theme               => $object->theme,
        _confirmation_method => $object->confirmation_method,
        _confirmation_text   => $object->confirmation_text,
        _confirmation_url    => $object->confirmation_url,
        _submission_method   => $object->submission_method,
        _submission_email    => $object->submission_email,
        _submission_email_subject   => $object->submission_email_subject,
        _total_database_submissions => $object->total_database_submissions,
        _nodes               => [],
        _added_nodes         => [],
        _updated_nodes       => [],
        _deleted_nodes       => [],
        _creator             => $object->creator,
    };
    bless $self, $class;
  
    # Load the nodes, if any
    foreach my $node ($object->nodes) {
        $self->add_node($node);
    }
    return $self;
}

##############################################################################
# Accessors
#


sub id {
  return $_[0]->{_id};
}

sub set_id {
    my $self = shift;
    my $id   = shift;
    
    if (!defined($id)) {
        Carp::carp("set_id() called with undefined value, no change made");
        return $self->{_id};
    }
    
    if ($id =~ /\D/) {
        Carp::carp("set_id() called with non digits, no change made");
        return $self->{_id};        
    }
    $self->{_id} = $id;
}

sub url {
    return $_[0]->{_url};
}

sub set_url {
    my $self = shift;
    my $url = shift;
    
    # if there was no url, set it to the empty string
    if (defined($url)) {
        $self->{_url} = $url;
    }
    else {
        $self->{_url} = "";
    }
    
    # we can't have a live form without a url
    if ($self->{_url} eq "") {
        $self->set_is_live(0);
    }
    
    return $url;
}

sub path {
    return $_[0]->{_path};
}

sub set_path {
    my $self = shift;
    my $path = shift;
    
    # if there was no path, set it to the empty string
    if (defined($path)) {
        $self->{_path} = $path;
    }
    else {
        $self->{_path} = "";
    }
    
    # we can't have a live form without a path
    if ($self->{_path} eq "") {
        $self->set_is_live(0);
    }
    
    return $path;
}


sub name {
    return $_[0]->{_name};
}

sub set_name {
    $_[0]->{_name} = $_[1];
}


sub description {
    return $_[0]->{_description};
}

sub set_description {
    $_[0]->{_description} = $_[1];
}


sub is_live {
    return $_[0]->{_is_live};
}

sub set_is_live {
    my $self = shift;
    my $value = shift;
    
    $value = 0 if !defined($value);
    $value = 0 if $value != 1;
    
    if (($value == 1) && ($self->path() eq "")) {
        $value = 0;
        Carp::carp("Form has no path, can't make live.");
    }
    $self->{_is_live} = $value;
}

sub is_deleted {
    return $_[0]->{_is_deleted};
}

sub set_is_deleted {
    $_[0]->{_is_deleted} = $_[1];
}

sub theme {
    return $_[0]->{_theme};
}

sub set_theme {
    $_[0]->{_theme} = $_[1];
}

sub confirmation_method {
    $_[0]->{_confirmation_method};
}

sub set_confirmation_method {
    my $self = shift;
    my $confirmation_method = shift;
    
    if (!(defined $confirmation_method)) {
        Carp::croak("set_confirmation_method called with undef value");
    }
    
    if (($confirmation_method ne "text") && ($confirmation_method ne "url")) {
        Carp::croak("set_confirmation_method only takes 'text' or 'url'" 
            . " but called with '$confirmation_method' "
            . "'"
        );
    }
    
    $self->{_confirmation_method} = $confirmation_method;
}

sub confirmation_text {
    $_[0]->{_confirmation_text};
}

sub set_confirmation_text {
    $_[0]->{_confirmation_text} = $_[1];
}

sub confirmation_url {
    $_[0]->{_confirmation_url};
}

sub set_confirmation_url {
    $_[0]->{_confirmation_url} = $_[1];
}

sub submission_method {
    $_[0]->{_submission_method};
}

sub set_submission_method {
    $_[0]->{_submission_method} = $_[1];
}

sub submission_email {
    return $_[0]->{_submission_email};
}

sub set_submission_email {
    $_[0]->{_submission_email} = $_[1];
}

sub submission_email_subject {
    return $_[0]->{_submission_email_subject};
}

sub set_submission_email_subject {
    $_[0]->{_submission_email_subject} = $_[1];
}

sub total_database_submissions {
    return $_[0]->{_total_database_submissions};
}

sub template {
    return $_[0]->{_template};
}

sub set_template {
    $_[0]->{_template} = $_[1];
}


sub css {
    return $_[0]->{_css};
}

sub set_css {
    $_[0]->{_css} = $_[1];
}

sub creator {
    return $_[0]->{_creator}
}

sub set_creator {
    $_[0]->{_creator} = $_[1];
}

##############################################################################
# Usage       : $form->has_required_fields
# Purpose     : Returns the number of required fields in the form. Good to 
#               determine whether to show the legend for required fields
# Returns     : a number between 0 and the total number of fields
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub has_required_fields {
    my $self = shift;
    my $count = grep $_->is_required, $self->nodes;
    return $count;
}

sub validation_profile {
    my $self = shift;
    my $validation_profile = {

        # Optional fields that are left empty are considered valid
        missing_optional_valid => 1,

        # Trim white space from the beginning and end of values before
        # the value is checked for constraints
        filters  => [qw( trim )],
        
        # The following are fields marked as required
        required => [],
        
        # The following are the option fields
        optional => [ qw/comments/ ],

        # The following are the option fields
        constraint_methods => {
            comments =>
                sub {
                    my $val = pop;
                    if ($val eq "") {
                        return 1;
                    }
                    else {
                        return 0;
                    }
                }
        },

        # 
        require_some => {},
                        
        # Set some properties 
        msgs => {
            # this prefix is used later, in the template
            prefix => 'error_',
            # the message to display when a field is missing
            missing => 'Please fill in the following:',
            # we handle the formatting through CSS
            format => '%s',
            # constraint-specific messages
            constraints => {
                'email' => 'Not a valid email format',
                'phone' => 'Not a valid phone format',
                'FV_URI_HTTP' => 'Not a valid URL format. (e.g. http://www.stanford.edu)',
            },
        },
    };
    
    foreach my $node (@{$self->nodes}) {
        my $node_validation_profile = $node->validation_profile;
        
        if (exists $node_validation_profile->{'required'}) {
            push( @{$validation_profile->{'required'}},
                  @{$node_validation_profile->{'required'}}
            );
        }

        if (exists $node_validation_profile->{'optional'}) {
            push( @{$validation_profile->{'optional'}},
                  @{$node_validation_profile->{'optional'}}
            );
        }
        
        if (exists $node_validation_profile->{'require_some'}) {
            foreach (keys %{$node_validation_profile->{'require_some'}} ) {
                $validation_profile->{'require_some'}{$_}
                    = $node_validation_profile->{'require_some'}{$_};
            }
        }
        
        if (exists $node_validation_profile->{'constraint_methods'}) {
            foreach (keys %{$node_validation_profile->{'constraint_methods'}} ) {
                $validation_profile->{'constraint_methods'}{$_}
                    = $node_validation_profile->{'constraint_methods'}{$_};
            }
        }
        
    }
    return $validation_profile;
}


sub exists {
  my $self = shift;
  if (@_) { $self->{_exists} = shift }
  return $self->{_exists};
}

sub templates_path {
  my $self = shift;
  if (@_) { $self->{_templates_path} = shift }
  return $self->{_templates_path};
}

sub date_created {
    return $_[0]->{_date_created};
}

##############################################################################
# Usage       : $form->set_to_deleted
# Purpose     : Updates the database so that a form is marked as deleted
# Returns     : ????
# Parameters  : A user identifier (e.g. username)
# Throws      : no exceptions
# Comments    : Forms aren't really deleted the first time around. A flag is
#               set so that we know a user meant to delete it, we keep track
#               of when the form was deleted and the user that asked for the
#               deletion. Forms are meant to be truly deleted later, after a
#               specified period of time has passed
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub set_to_deleted {
    my $self = shift;
    my $user = shift;   # who deleted the form?
    
    # We set the deleted flag for the form in memory
    $self->is_deleted(1);

    # Does the form exist in the database? If not, don't do anything.
    # Forms don't have an ID unless they have been stored at some
    # point.
    return unless defined $self->id;

    my $stored_form = FB::DB::Form->retrieve($self->id);
    
    # This function sets is_deleted to 1, marks the date this form was
    # deleted and stores the name of the user who deleted this form
    # if one was passed.
    $stored_form->set_to_deleted($user);

    return;
}

##############################################################################
# Usage       : $form->store();
# Purpose     : Stores the form in the database
# Returns     : The Database ID for the form
# Parameters  : none
# Throws      : no exceptions
# Comments    : To decide whether the form exists in the database or not we
#               check for the form's ID. If there is one, we update the
#               form. If there isn't, we create the form.
# See Also    : n/a

# TODO: Error Checking

sub store {
    my $self = shift;
    my $form_id;
    
        
    # Does the form have an ID? If so, update the record
    if (defined($self->id)) {
        
        # Retrieve the form from storage
        my $stored_form = FB::DB::Form->retrieve($self->id);
        
        # Update the values of the form in storage
        $stored_form->set(
            path                => $self->path,
            url                 => $self->url,
            name                => $self->name,
            description         => $self->description,
            is_live             => $self->is_live,
            is_deleted          => $self->is_deleted,
            template            => $self->template,
            css                 => $self->css,
            confirmation_method => $self->confirmation_method,
            confirmation_text   => $self->confirmation_text,
            confirmation_url    => $self->confirmation_url,
            submission_method   => $self->submission_method,
            submission_email    => $self->submission_email,
            submission_email_subject    => $self->submission_email_subject,
            creator             => $self->creator,
        );

        $stored_form->update;
        
        # saved for return purposes
        $form_id = $stored_form->id;
    }
    else {
        # This is a new form object, so we'll insert it into the database
        my $stored_form
            = FB::DB::Form->insert({ 
                path                => $self->path,
                url                 => $self->url,
                name                => $self->name,
                description         => $self->description,
                is_live             => $self->is_live,
                is_deleted          => $self->is_deleted,
                template            => $self->template,
                css                 => $self->css,
                confirmation_method => $self->confirmation_method,
                confirmation_text   => $self->confirmation_text,
                confirmation_url    => $self->confirmation_url,
                submission_method   => $self->submission_method,
                submission_email    => $self->submission_email,
                submission_email_subject    => $self->submission_email_subject,
                creator             => $self->creator,
            });
        
       # We set the ID of the in-memory form to that of the stored form
        $self->set_id($stored_form->id);
        
        $form_id = $stored_form->id;
    }
    
    #########################################################################
    # Process the form's nodes
    
    
    # Process any deleted nodes
    foreach my $deleted_node ($self->deleted_nodes) {
        
        # Delete the connection between the form and the node
        FB::DB::Node->search(
            form_id    => $form_id,
            element_id => $deleted_node->id   
        )->delete_all;
        
        # Delete the node from the database
        $deleted_node->remove_from_store;
        
        # If there is a database for storing submissions,
        # delete the columns that correspond to this node
    }
    
    # Process any new nodes
    foreach my $added_node ($self->added_nodes) {
        
        # If there is a database for storing submissions,
        # add the appropriate columns for this node

    }
    
    # Update any remaining nodes
    if ($self->nodes) {
        my @nodes = $self->nodes;
        
        # Loop through the nodes. We use for rather than foreach
        # as we need the index number for the node to save it as
        # the sort_order in the database
        for (my $i = 0; $i <= $#nodes; $i++) {
            
            # Tell the node to store itself (it'll do the right thing
            # based on what type of object it is)
            my $node_id = $nodes[$i]->store;
            
            # Find or create a connection between the node and this
            # form in the database.
            my $node_connection = FB::DB::Node->find_or_create(
                form_id    => $form_id, 
                element_id => $node_id,
                );
                
            # Update the connection. The sort order is updated if a node
            # was moved around. Also update the node type in case in the
            # future it's possible to change node types (from checkboxes
            # to radio buttons, for example)
            $node_connection->set(
                node_type  => $nodes[$i]->type, 
                sort_order => $i,
                );
            
            # Make sure the changes are saved.
            $node_connection->update;
        }
    }
    
    #########################################################################
    # Update the form's submission database

    # Are there added or deleted fields?
    if ($self->added_nodes || $self->deleted_nodes || $self->updated_nodes) {


        # First, grab the database handle we are already using
        my $dbh = FB::DB->db_Main();

        # If there is a submission database, we update it
        if ($self->has_submission_database($dbh) == 1) {
            # Process any deleted nodes
            foreach my $node ($self->deleted_nodes) {
                next unless $node->can_be_submitted;
                $self->remove_node_from_submission_database($node, $dbh);
            }
            
            # Process any new nodes
            foreach my $node ($self->added_nodes) {
                next unless $node->can_be_submitted;
                $self->add_node_to_submission_database($node, $dbh);
            }
            
            # Process any updated nodes; these are nodes with added/deleted
            # elements
            foreach my $node ($self->updated_nodes) {
                next unless $node->can_be_submitted;
                $self->update_node_in_submission_database($node, $dbh);
            }
        }
    }
    
    # If the form is live, is supposed to save submissions into a
    # database and such database doesn't already exist, create one
    if ( $self->is_live
        && ($self->submission_method eq "database"
            || $self->submission_method eq "both")
       ) {
           
        # set the database name, using form_ as the prefix and the form id
        my $db_name = "form_" . $self->id;
        
        # First, grab the database handle we are already using
        my $dbh = FB::DB->db_Main();


        # If there is no submission database, we create one
        if ($self->has_submission_database($dbh) == 0) {
            
            # create database
            $dbh->do("create database $db_name");
            
            # now create submission table
            my $statement = "create table $db_name.submission (`submission_id` int(11) UNSIGNED NOT NULL auto_increment,`date_submitted` timestamp NOT NULL default CURRENT_TIMESTAMP,`remote_user` varchar(255) DEFAULT NULL,`remote_host` varchar(255) DEFAULT NULL, PRIMARY KEY  (`submission_id`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;";
            $dbh->do($statement);
            
            foreach my $node ($self->nodes) {
                next unless $node->can_be_submitted;
                $self->add_node_to_submission_database($node, $dbh);
            }
        }
    }


    return $form_id;
}

sub has_submission_database {
    my $self = shift;
    my $dbh = shift;
    
    # set the database name, using form_ as the prefix and the form id
    my $db_name = "form_" . $self->id;
    
    # Find out if a submission database for this form exists
    my ($db_count) = $dbh->selectrow_array(
              "select count(*) "
            . "from information_schema.schemata "
            . "where schema_name = ?",
            undef,
            $db_name
        );

    return $db_count;
}

sub add_node_to_submission_database {
    my $self = shift;
    my $node = shift;
    my $dbh = shift;

    my $db_name = "form_" . $self->id;
    
    if ($node->can_have_elements) {
        foreach my $sub_element (@{$node->elements}) {
            $self->add_node_to_submission_database($sub_element, $dbh);
        }
    }
    else {
        # TODO: need to check that there is, indeed, a name
        # TODO: make sure that the column doesn't already exist
        my $field_name = $node->name;
        if ($node->type eq "textarea") {
          $dbh->do("ALTER TABLE $db_name.submission ADD $field_name text DEFAULT NULL;");
        }
        else {
          $dbh->do("ALTER TABLE $db_name.submission ADD $field_name varchar(500) DEFAULT NULL;");
        }
    }
}
sub update_node_in_submission_database {
    my $self = shift;
    my $node = shift;
    my $dbh = shift;
    
    my $db_name = "form_" . $self->id;

    if ($node->can_have_elements) {
        foreach my $sub_element (@{$node->added_elements}) {
            $self->add_node_to_submission_database($sub_element, $dbh);
        }
    }
    
    if ($node->can_have_elements) {
        foreach my $sub_element (@{$node->deleted_elements}) {
            $self->remove_node_from_submission_database($sub_element, $dbh);
        }
    }
}

sub remove_node_from_submission_database {
    my $self = shift;
    my $node = shift;
    my $dbh = shift;
    
    my $db_name = "form_" . $self->id;
    
    if ($node->can_have_elements) {
        foreach my $sub_element (@{$node->elements}) {
            $self->remove_node_from_submission_database($sub_element, $dbh);
        }
    }
    else {
        my $field_name = $node->name;
        # TODO: need to check that there is, indeed, a name
        # TODO: make sure that the column does exist
        $dbh->do("ALTER TABLE $db_name.submission DROP $field_name");
    }
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

sub added_nodes {
    wantarray ? @{$_[0]->{_added_nodes}} : $_[0]->{_added_nodes};  
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

sub updated_nodes {
    wantarray ? @{$_[0]->{_updated_nodes}} : $_[0]->{_updated_nodes};  
}

sub add_to_updated_nodes {
    my $self = shift;
    my $node = shift;
    push (@{$self->{_updated_nodes}}, $node);
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

sub deleted_nodes {
  wantarray ? @{$_[0]->{_deleted_nodes}} : $_[0]->{_deleted_nodes};  
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

sub nodes {
    wantarray ? @{$_[0]->{_nodes}} : $_[0]->{_nodes};  
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

sub get_node_at {
    my $self = shift;
    my $location = shift; 
    return @{$self->{_nodes}}[$location];
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

sub add_node {
    my $self = shift;
    my $node = shift;

    # Is the node being added coming from a database? If so read it in.
    if ($node->isa("FB::DB::Node")) {
        my $node_type = $node->node_type;
        my $class = FB->get_class_from_type($node_type);
        my $new_node = $class->new_from_store($node->element_id);
        $node = $new_node;
    }
    else {
        # We only add this node to the list of added nodes if it
        # didn't come from a database, since the _added_nodes array is there
        # to keep track of newly added nodes only
        push (@{$self->{_added_nodes}}, $node);
    }

    $node->form($self);
    push (@{$self->{_nodes}}, $node);
    my @nodes = @{$self->nodes};
    return $#nodes;
}

##############################################################################
# Usage       : $form->add_note_at($node, 2)
# Purpose     : Add a node at the location specified
# Returns     : ????
# Parameters  : node and location
# Throws      : no exceptions
# Comments    : Not in use right now
# See Also    : n/a

#sub add_node_at {
#    my $self = shift;
#    my $node = shift;
#    my $location = shift;
#
#    # let the node know which form it belongs to
#    $node->form($self);
#    push (@{$self->{_added_nodes}}, $node);
#    splice(@{$self->{_nodes}}, $location, 0, $node);
#}

##############################################################################
# Usage       : $form->remove_node_at($node_position, $node_id);
# Purpose     : Removes a node from _nodes array and forwards request to node
# Returns     : deleted node
# Parameters  : location (0 index) of node, and node ID
# Throws      : no exceptions
# Comments    : We use the node position to remove the node from the nodes
#               array for the form, and the node_id as a safety check to make
#               sure we are in fact deleting the right node. We don't use
#               the node_id to pull up the node because we work at the level
#               of forms, where it's easier to check whether the current user
#               has the right permissions.
# See Also    : n/a

sub remove_node_at {
    my $self     = shift;
    my $location = shift;
    my $node_id  = shift;

    # Does the location exist? Get the last node index
    my $last_node_index = $#{$self->nodes};
    
    # Skip if we are trying to delete a node that doesn't exist
    return if $location > $last_node_index;

    # Check if the node being delete has the correct ID
    # It wouldn't if the user had hit refresh in their browser
    # window
    return if $self->get_node_at($location)->id != $node_id;
    
    # remove the node from the list, and store it temporarily
    my $deleted_node = splice(@{$self->{_nodes}}, $location, 1);
    push (@{$self->{_deleted_nodes}}, $deleted_node);

    # tell node to delete itself from store
    $deleted_node->remove_from_store;

    return $deleted_node;
}

##############################################################################
# Usage       : $form->move_node_up(2);
# Purpose     : Move the node at the location specified up
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : index is 0-based
# See Also    : n/a


sub move_node_up {
    my $self  = shift;
    my $current_location = shift;

    # Can't move the node up if it's at the top
    return if $current_location == 0;
    
    my $new_location     = $current_location - 1;
 
    # check that current location is within number of nodes
    my @nodes = @{$self->nodes};
    return if ($#nodes < $current_location);

    my $node_to_move = splice(@{$self->{_nodes}}, $current_location, 1);
    splice(@{$self->{_nodes}}, $new_location, 0, $node_to_move);
}

##############################################################################
# Usage       : $form->move_node_down(2);
# Purpose     : Move the node at the location specified down
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : index is 0-based
# See Also    : n/a

sub move_node_down {
    my $self  = shift;
    my $current_location = shift;
    my $new_location     = $current_location + 1;
 
    # check that the new location is within number of nodes
    my @nodes = @{$self->nodes};
    return if ($#nodes < $new_location);

    my $node_to_move = splice(@{$self->{_nodes}}, $current_location, 1);
    splice(@{$self->{_nodes}}, $new_location, 0, $node_to_move);
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

sub as_html {
    my $self = shift; 
    my $page = shift;
    my $html_output = "";
    my $template = Template->new( { 
        INCLUDE_PATH => $self->templates_path
    });
    $template->process(
        $self->template,
        { form => $self, page => $page },
        \$html_output,
    ) or die $template->error();
    return $html_output;
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
# TODO: The rendering code should first check for a cached version of the form
# and return that if it exists

sub render {
    my $self = shift;
    my $page = shift;
    print $self->as_html($page);
}

1;
