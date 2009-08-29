#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB;
use warnings;
use strict;

use CGI ':cgi-lib';
use utf8;
use CGI::Carp;

$CGI::POST_MAX=1024 * 512;  # max 512K posts
$CGI::DISABLE_UPLOADS = 1;  # no uploads

use Template;
use FB::DB;
use FB::Form;
use FB::User;
use FB::Form::Element;
use FB::Form::Element::Input;
use FB::Form::Element::Input::Email;
use FB::Form::Element::Input::Phone;
use FB::Form::Element::Input::URL;
use FB::Form::Element::TextArea;
use FB::Form::Element::Select;
use FB::Form::Element::Select::Item;
use FB::Form::Element::Select::ItemSet;
use FB::Form::Element::Select::Country;
use FB::Form::Element::Select::Service;
use FB::Form::Element::Select::RadioGroup;
use FB::Form::Element::Select::CheckBoxGroup;
use FB::Form::Element::Select::LikertItem;
use FB::Form::Element::Output;
use FB::Form::Element::Output::SectionHeader;
use FB::Form::Collection;
use FB::Form::Collection::Name;
use FB::Form::Collection::Address;
use FB::Form::Collection::Likert;
use FB::Localization;
use FB::Theme;
use FB::Theme::Stanford;
use FB::Theme::Plain;
use FB::Validation qw(trim is_1_or_0);
use URI::URL;

use Data::FormValidator;
use Data::FormValidator::Constraints qw(:closures :regexp_common);




our $Debug = 0;

{
  my %classes = (
    'output_section_header' => "FB::Form::Element::Output::SectionHeader",
    
    'collection'            => "FB::Form::Collection",
    'collection_name'       => "FB::Form::Collection::Name",
    'collection_address'    => "FB::Form::Collection::Address",
    'collection_likert'     => "FB::Form::Collection::Likert",

    'select'                => "FB::Form::Element::Select",
    'select_radio'          => "FB::Form::Element::Select::RadioGroup",
    'select_checkbox'       => "FB::Form::Element::Select::CheckBoxGroup",
    'select_country'        => "FB::Form::Element::Select::Country",
    'select_services'       => "FB::Form::Element::Select::Service",
    'select_likert'         => "FB::Form::Element::Select::LikertItem",

    'input'                 => "FB::Form::Element::Input",
    'input_email'           => "FB::Form::Element::Input::Email",
    'input_phone'           => "FB::Form::Element::Input::Phone",
    'input_url'             => "FB::Form::Element::Input::URL",

    'textarea'              => "FB::Form::Element::TextArea",
  );
  
  sub get_class_from_type {
    my $self = shift;
    my $type = shift;
    return $classes{$type};
  }
  
  my %templates = (
    'output_section_header' => "section_header.tt",
    'collection'            => "fieldset.tt",
    'collection_name'       => "fieldset.tt",
    'collection_address'    => "fieldset.tt",
    'collection_likert'     => "likert.tt",
    'select_radio'          => "radiogroup.tt",
    'select_checkbox'       => "checkboxgroup.tt",
    'select_country'        => "select.tt",
    'select_services'       => "select.tt",
    'select_likert'         => "likert/item.tt",
    'input'                 => "input_text.tt",
    'input_email'           => "input_text.tt",
    'input_phone'           => "input_text.tt",
    'input_url'             => "input_text.tt",
    'textarea'              => "textarea.tt",
  );

  sub get_template_from_type {
    my $self = shift;
    my $type = shift;
    return $templates{$type};
  }

}

##############################################################################
# Usage       : $fb->new
# Purpose     : ????
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking

sub new {
  my $class = shift;
  my $self  = {};
  $self->{_cgi} = new CGI;
  $self->{_cgi}->charset( "utf-8" );
  $self->{_method} = $self->{_cgi}->request_method();
  $self->{_path}   = $ENV{PATH_TRANSLATED};
  $self->{_page} = {};
  $self->{_node} = {};
  $self->{_values} = {};
  bless ($self, $class);
  if (@_) { $self->_init(@_); }
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

sub _init {
    my $self = shift;
    my $config = shift;

    # let's get a language handle
    $self->{_language_handle}
        = FB::Localization->get_handle($config->language) or die "no handle?";
    $self->{_templates_path}     = $config->templates_path;
    $self->{_max_forms_per_user} = $config->users_max_forms;
    $self->{_can_create_new_users} = $config->users_can_create_new || 0;
    $self->{_can_create_new_users_automatically}
        = $config->users_can_create_automatically || 0;
	$self->{_domain_name} = $config->domain_name;
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

sub templates_path {
  my $self = shift;
  return $self->{_templates_path};
}

sub domain_name {
	my $self = shift;
	return $self->{_domain_name};
}

sub form {
  return $_[0]->{_form};
}

sub set_form {
    my $self = shift;
    if (@_) { 
      my $form = shift;
      $self->{_form} = $form;
      $form->templates_path($self->templates_path);
    }
    return $self->{_form};
}

sub method {
  my $self = shift;
  return $self->{_method};
}

sub cgi {
  my $self = shift;
  return $self->{_cgi};
}

sub page {
    return $_[0]->{_page};
}

sub node {
    return $_[0]->{_node};
}

sub set_node {
    $_[0]->{_node} = $_[1];
}

sub user {
    return $_[0]->{_user};    
}

sub set_user {
    $_[0]->{_user} = $_[1];
}


sub values {
    return $_[0]->{_values};
}

sub language_handle {
  my $self = shift;
  return $self->{_language_handle};
}

sub max_forms_per_user {
    return $_[0]->{_max_forms_per_user};
}

sub can_create_new_users {
    return $_[0]->{_can_create_new_users};    
}

sub can_create_new_users_automatically {
    return $_[0]->{_can_create_new_users_automatically};    
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

sub print_message {
  my $self = shift;
  my $message = shift;
  print $self->cgi->header;
  print $self->language_handle->maketext($message) . "\n";
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

sub debug {
  my $self = shift;
  my $data = shift;
  use Data::Dumper;
  use CGI;
  my $q = new CGI;
  print $q->header;
  print Dumper $data;
}

##############################################################################
# Usage       : $fb->run
# Purpose     : Runs the application, which decides whether to render a form
#               or process it
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : This particular function could be taken out of this file and
#               placed into a different rendering/processing only file if
#               we need to for speed reasons
# See Also    : n/a

# TODO: Error Checking

sub run {
    my $self = shift;
    my $cgi = $self->cgi;
    
    my $form_id = $self->cgi->param('form_id');
    my $form;

    if (defined $form_id) {
        eval {
            $form = FB::Form->new_from_store($form_id);
        };
    }
    else {
        eval {
            $form = FB::Form->new_from_path($self->{_path});
        }
    }

    if ($@) {
        $self->display_error(
            status => "404 Not Found",
            user_header => "404 Form Not Found",
            user_message => "The form you requested does not exist.",
            );
        exit;
    }
    
    if ($form) {
        $form->exists(1);
        $self->set_form($form);
    }
    
    if (!$self->form->is_live || $self->form->is_deleted) {
        $self->display_error(
            status => "404 Not Found",
            user_header => "404 Form Not Found",
            user_message => "The form you requested does not exist.",
            );
        exit;
    }

    # If the method is POST, we assume the form has been posted and check
    # whether it's valid.
    if ($self->method eq "POST") {
        # We build the validation profile for this form.
        # TODO: Cache this validation profile so that it doesn't have to be
        # built every time the form is POSTed
        my $validation_profile = $self->form->validation_profile;
        my $results = Data::FormValidator->check($cgi, $validation_profile);
        
        if ($results->success) {
            
            FB::DB::Form->update_submission_count($self->form->id);
            
            
            my %values;
            foreach my $field ($results->valid) {
                $values{$field} = $results->valid($field);
            }
            
            # If the form was successfully submitted, we look to what kind of
            # message we need to send.
            
            if (($self->form->submission_method eq "email") ||
                ($self->form->submission_method eq "both")) {
                
                my %submission;
                $submission{'timestamp'} = localtime;
                $submission{'remote_user'} = $self->cgi->remote_user;
                $submission{'remote_host'} = $self->cgi->remote_host;
                
                my $email_output = "";
                my $template = Template->new({
                    INCLUDE_PATH => $self->templates_path
                });

                $template->process(
                    'email/main.tt',
                    { submission => \%submission,
                      values => \%values,
                      form => $self->form },
                    \$email_output
                ) or die $template->error();
                
                use Mail::Mailer;
                my $mailer = Mail::Mailer->new('smtp', Server => 'smtp.stanford.edu'); #$server"sendmail");
                $mailer->open({
                        From    => "nobody\@stanford.edu",
                        To      => $self->form->submission_email,
                        Subject => $self->form->submission_email_subject,
                })
                or Carp::croak "Can't open emailer $!\n";
                print $mailer $email_output;
                $mailer->close();
            }

            if (($self->form->submission_method eq "database") ||
                ($self->form->submission_method eq "both")) {
                # First, we check if there is a submission database
                # If there isn't we should probably fail
                my $dbh = FB::DB->db_Main();
                 
                my @field_names;
                my @field_values;
                
                foreach my $field ($results->valid) {
                    next unless defined($results->valid($field));
                    my @values = $results->valid($field);
                    push (@field_names, $field);
                    push (@field_values, $dbh->quote(join("\n",@values)));
                }
                
                # Also store the remote_user and the remote_host
                # TODO: We might allow, in the future, the ability to create
                # "anonymous" forms, which means these won't get logged
                push(@field_names, 'remote_user');
                push(@field_values, $dbh->quote($self->cgi->remote_user));
                push(@field_names, 'remote_host');
                push(@field_values, $dbh->quote($self->cgi->remote_host));
                
                # TODO: We could prepare a statement that has all fields,
                # all the time, and that might take advantage of the database
                # resources...
                
                my $statement
                    = "INSERT INTO form_" . $self->form->id . ".submission "
                    . "(" . join(",", @field_names) . ")"
                    . " VALUES "
                    . "(" . join(",", @field_values) . ")"
                    . ";"
                    ;
                
                # Let's try to save the data to the database
                eval {
                    $dbh->do($statement);
                };
                if ($@) {
                    # TODO: OK, something went wrong we should:
                    # let the user know, so they can try again
                    # log the error
                    # save the data, so it's not completely lost
                    Carp::croak("Could not save submission to the database. $@");
                    return;
                }
                
                FB::DB::Form->update_database_submission_count(
                    $self->form->id
                );
                
            }

            # After we've saved the data, or emailed it, we need to return
            # a message to the person who submitted the form. Here we choose
            # whether to send them a confirmation message or redirect them
            # to a different page
            
            if ($self->form->confirmation_method eq "text") {
                $self->page->{'success'}{'message'}
                    = $self->form->confirmation_text;
                print $self->cgi->header;
                $self->form->render($self->page);
                exit;
            }
            
            if ($self->form->confirmation_method eq "url") {
                print $self->cgi->redirect($self->form->confirmation_url);
                exit;
            }
        }
        else {
            # validation has failed, so we need to respond to the user with
            # instructions on how to fix the problem
            
            # get a hash with all submitted values through CGI.pm
            my %submitted_values = %{$cgi->Vars};
            
            # Update the template's values with those just passed by the user
            # We do this to keep state and not delete the user's entries
            # when there is a mistake on some part of the form
            foreach my $field ($results->valid) {
                $self->values->{'form'}{$field} = $submitted_values{$field};
            }
            
            foreach my $field ($results->missing) {
                $self->values->{'form'}{$field} = $submitted_values{$field};
            }
            
            # Create the error message
            $self->page->{'errors'}{'main'}{'header'} .= "Error";
            $self->page->{'errors'}{'main'}{'message'}
                .= "There were some errors.<br />Please see below.";

            # Pass the individual error messages (e.g. this is missing,
            # that is invalid) to the template. The actual messages are stored
            # in the validation profile
            my %error_messages = %{$results->msgs};
            foreach (keys %error_messages) {
                $self->page->{'errors'}{$_} = $error_messages{$_};
            }
            
            print $self->cgi->header;
            $self->form->render($self->page);
        }
        exit;
    }

    if ($self->method eq "GET") {
        print $self->cgi->header;

        # are we behind WebAuth?
        foreach my $node ($form->nodes) {
            if (defined($node->is_autofilled) && ($node->is_autofilled)) {
                if ($node->type eq "input_email") {
                    $node->set_value($ENV{'REDIRECT_WEBAUTH_LDAP_MAIL'});
                }

                if ($node->type eq "collection_name") {
#                    use Stanford::Directory;
#                   my $DIR = new Stanford::Directory;
#                    $DIR->set (ldap_server    => "ldap.stanford.edu",
#                               mechanism      =>  "GSSAPI",
#                               basedn         => "cn=people, dc=stanford, dc=edu");

#                    my $sunetid = $ENV{'WEBAUTH_USER'};
#                    my @entries = $DIR->ldap_query("(uid=$sunetid)");

#                    my %userinfo;
#                    my $user;

#                    foreach my $entry (@entries) {
#                        $user = $entry;
#                        foreach my $attr (keys (%{$entry})) {
#                            push @{$userinfo{$attr}}, @{$entry->{$attr}};
#                        }
#                    }

                    my @elements = $node->elements;
#                    my ($last, $first) = split(",",$userinfo{'sudisplaynamelf'}[0]);
                    my @names = split(" ",$ENV{'REDIRECT_WEBAUTH_LDAP_DISPLAYNAME'});
                    my $last_name  = $names[$#names];
                    my $first_name = $names[0];
                    $elements[0]->set_value(trim($first_name));
                    $elements[1]->set_value(trim($last_name));
                }
            } 
        }

        $self->form->render;

        # TODO: decide if you want to keep this format for debugging
        $Debug && warn Dumper $self->form;
    }
}

##############################################################################
# Usage       : $fb->manage($identifier)
# Purpose     : Prints the management screen for the user identified
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking

sub manage {
    my ($self, %args) = @_; 
    my $user = $self->user;
       
    my $html_output = "";
    my $template = Template->new({
        INCLUDE_PATH => $self->templates_path
    });
    
    $template->process(
        'formmanager.tt',
        { user => $user, page => $self->page, },
        \$html_output
    ) or die $template->error();
        
    print $self->cgi->header;
    print $html_output;
    exit;
}

##############################################################################
# Usage       : $fb->build($identifier)
# Purpose     : Prints the editing screen
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: A node should be identified by both position and element/collection ID
#       That way, we can compare them to see if the request is a repeat
#       or a new one. (As you would get if you refreshed the browser after
#       deleting the node at position X)

sub build {
    my $self = shift;
    
    # Get the identifier from REMOTE_USER unless we are overriding it for
    # testing purposes
    # TODO: remove the "unless $identifier" bit before making this live
    my $identifier = $self->cgi->remote_user();
   
    # The formbuilder needs to be provided with an identifier;
    # without it we quit and return an error.
    # In Stanford's case, the identifier is the SUNET_ID
    if ((!defined $identifier) || (trim($identifier) eq "")) {
            $self->display_error(
                error_message => 
                      "The form builder needs a user identifier in order "
                    . "to work. Perhaps the formbuilder is no longer behind "
                    . "HTTP Authentication?",
                fatal => 1);
    }
    
    # At this point we have an identifier which we should use to
    # find an existing user, or create a new user
    # If neither is possible, we should fail
    my $existing_user = FB::User->new_from_store($identifier);

    # Does a record for this user exist? If yes, use that
    if ($existing_user) {
        $self->set_user($existing_user);
    }
    else {
        # Since a record doesn't exist, we'll check to see if we are
        # allowed to create new users. We might not be allowing new users
        # if it's a closed beta, for example.
        if ($self->can_create_new_users) {
            # If we are allowed to create new users, are we allowed to do
            # so automatically, or do we need to process new users some
            # other way?
            # TODO: Error Checking - what if the creation fails
            if ($self->can_create_new_users_automatically) {
                # TODO: move this bit of Stanford-specific code
                my $new_user = FB::User->new(
                    email      => $ENV{'WEBAUTH_LDAP_MAIL'},
                    name       => $ENV{'WEBAUTH_LDAP_DISPLAYNAME'},
                    identifier => $identifier,
                    max_forms  => $self->max_forms_per_user,
                );
                $new_user->store();
                $self->set_user($new_user);
            }
            else {
                # TODO: Add a system-wide setting for "administrator"
                # so that we can reuse that information (name/phone/email)
                # in all these types of messages.
                # display_error exits the program
                $self->display_error(
                    user_message => "New accounts can be created, "
                    . "but no automatic user creation is allowed. "
                    . "Please contact administrator.");                
            }
        }
        else {
            # display_error exits the program
            $self->display_error(
                user_message => "Cannot create new user accounts at this "
                . "time. Please contact administrator.");
        }
    }
    
    # Is the user active? If yes, continue, but if not, display error.
    # TODO: Should we have a message that's specific for the user about
    # why their account is not active?
    if (!$self->user->is_active) {
        $self->display_error(
            user_header   => "Account is inactive",
            user_message  => "Your account has been set as inactive. Please contact the administrator for help.");
    }

    # This is a list of actions the formbuilder can perform.
    my %allowed_actions = (
        create_new_form             => 1,
        confirm_delete_form         => 1,
        edit_form                   => 1,
        duplicate_form              => 1,
        delete_form                 => 1,
        add_form_by_url             => 1,
        add_node                    => 1,
        move_node_down              => 1,
        move_node_up                => 1,
        edit_node                   => 1,
        delete_node                 => 1,
        edit_form_properties        => 1,
        save_form_properties        => 1,
        save_field_properties       => 1,
        save_publishing_settings    => 1,
        view_entries                => 1,
        delete_entries              => 1,
        delete_entries_confirm      => 1,
        export_entries_as_excel     => 1,
        export_entries_as_csv       => 1,
    );
    
    # Let's see what action the user wants to perform
    my $action = $self->cgi->param('action');

    # If no action was passed, or it's not allowed, send the user to the
    # management screen.
    if (!(defined $action) || !(exists $allowed_actions{$action})) {
        # TODO: Log that non-allowed action was requested
        $self->manage;
    }

    if ($action eq "add_form_by_url") {
        $self->add_form_by_url();
        $self->manage;
    }

    # set some constants for the tabs used in the build screens
    use constant {
        BUILD_TAB   => 0,
        EDIT_TAB    => 1,
        PUBLISH_TAB => 2,
    };
    
    # By default, we start on the build tab. This can be changed
    # by a function below as appropriate
    $self->page->{'tab_number'} = BUILD_TAB;
    
    
    # We now need a form. We first check if it needs to be created or
    # it's an existing one
    
    # User has requested to create a new form
    if ($action eq "create_new_form") {
        $self->create_new_form();
        $self->fill_publishing_settings;
    }
    else {
        my $form_id = $self->cgi->param('form_id');
        my $action  = $self->cgi->param('action');

        # Retrieve the form, given the ID
        my $form = FB::Form->new_from_store($form_id);
        if ($form) {
            $form->exists(1);
            $self->set_form($form);
        }

        # Check to make sure the form hasn't been deleted before we continue
        if ($self->form->is_deleted) {
            Carp::croak(
                  "User: " . $self->user->identifier . " "
                . "Form: " . $form->id . " "
                . "Error: User can't edit this form, it has been deleted."
                );
        }

        
        # Check to make sure the user can edit this form before we continue.
        if (!$self->user->can_edit($form)) {
            Carp::croak(
                  "User: " . $self->user->identifier . " "
                . "Form: " . $form->id . " "
                . "Error: User can't edit this form."
                );
        }
        
        $self->fill_publishing_settings unless ($action eq "view_entries") || ($action eq "export_entries_as_excel");
        
        $self->$action;
    }

    # We now display the form building interface
    $self->edit_form();
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

sub view_entries {
    my $self = shift;
    my $form = $self->form;

    # Check if there is, in fact, a submissions database. If there isn't one,
    # send the user back to the Form Management Screen
    my $dbh = FB::DB->db_Main();
    if ($form->has_submission_database($dbh) == 0) {
        $self->page->{'message'}
            .= "The form you selected is not saving data to a database.";
        $self->manage();
    }
    
    my @field_labels = ("id", "Submitted By", "Date Submitted");
    my @field_names  = qw/submission_id remote_user date_submitted/;
    
    foreach my $node ($form->nodes) {
        next unless $node->can_be_submitted;
        if ($node->can_have_elements) {
            foreach my $element ($node->elements) {
                push (@field_labels, $node->label . ":" . $element->label);
                push (@field_names,  $element->name);
            }
        }
        else {
            push (@field_labels, $node->label);
            push (@field_names,  $node->name);
        }
    }
    
    my $statement
        = "SELECT " 
         . join(',', @field_names) 
         . " FROM "
         . "form_" . $form->id . ".submission"
         . " ORDER BY submission_id DESC;"
         ;
    my $data_ref = $dbh->selectall_arrayref($statement);

    my $html_output = "";
    my $template = Template->new({
        INCLUDE_PATH => $self->templates_path
    });

    $template->process(
        'data_viewer.tt',
        {   user => $self->user, 
            form => $self->form, 
            page => $self->page,
            field_labels => \@field_labels,
            field_names  => \@field_names,
            data => $data_ref,
        },
        \$html_output
    ) or die $template->error();
    
    print $self->cgi->header;
    print $html_output;    
    exit;
}

##############################################################################
## Usage       : ????
## Purpose     : ????
## Returns     : ????
## Parameters  : none
## Throws      : no exceptions
## Comments    : none
## See Also    : n/a

## TODO: Error Checking
## TODO: Testing Code

sub delete_entries_confirm {
    my $self = shift;
    my $form = $self->form;

    # Check if there is, in fact, a submissions database. If there isn't one,
    # send the user back to the Form Management Screen
    my $dbh = FB::DB->db_Main();
    if ($form->has_submission_database($dbh) == 0) {
        $self->page->{'message'}
            .= "The form you selected is not saving data to a database.";
        $self->manage();
    }

    my $html_output = "";
    my $template = Template->new({
        INCLUDE_PATH => $self->templates_path
    });

    my @submission_ids = $self->cgi->param('submission_id');

    my $total_submissions = scalar(@submission_ids);

    # If there are no submissions, go back to the view entries screen
    if ($total_submissions == 0) {
       $self->view_entries;
    }

    $template->process(
        'data_viewer/delete_confirm.tt',
        {   user => $self->user,
            form => $self->form,
            page => $self->page,
            total_submissions => $total_submissions,
            submissions => \@submission_ids,
        },
        \$html_output
    ) or die $template->error();

    print $self->cgi->header;
    print $html_output;
    exit;

}

##############################################################################
## Usage       : ????
## Purpose     : ????
## Returns     : ????
## Parameters  : none
## Throws      : no exceptions
## Comments    : none
## See Also    : n/a

## TODO: Error Checking
## TODO: Testing Code

sub delete_entries {
    my $self = shift;
    my $form = $self->form;

    # Check if there is, in fact, a submissions database. If there isn't one,
    # send the user back to the Form Management Screen
    my $dbh = FB::DB->db_Main();
    if ($form->has_submission_database($dbh) == 0) {
        $self->page->{'message'}
            .= "The form you selected is not saving data to a database.";
        $self->manage();
    }

    my $html_output = "";
    my $template = Template->new({
        INCLUDE_PATH => $self->templates_path
    });

    my @submission_ids = $self->cgi->param('submission_id');

    my $total_submissions = scalar(@submission_ids);

    # If there are no submissions, go back to the view entries screen
    if ($total_submissions == 0) {
       $self->view_entries;
    }

    my $statement
        = 'delete from '
        . 'form_' . $self->form->id . '.submission '
        . 'where submission_id = ?'
        ;
    my $sth = $dbh->prepare($statement);
    foreach my $submission_id (@submission_ids) {
        $sth->execute($submission_id);
    }

    my ($total_database_submissions)
		= $dbh->selectrow_array('select count(1) from form_' . $self->form->id . '.submission ');

	FB::DB::Form->set_database_submission_count($self->form->id, $total_database_submissions);
	
    if ($total_submissions == 1) {
        $self->page->{'message'} .= 'One entry was deleted.';
    }
    else {
        $self->page->{'message'} .= "$total_submissions entries were deleted.";
    }

    $self->view_entries;
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

sub export_entries_as_csv {
    my $self = shift;
    my $form = $self->form;
    
    use Text::CSV;
    my $csv = Text::CSV->new({binary => 1});
    
    
    # Check if there is, in fact, a submissions database. If there isn't one,
    # send the user back to the Form Management Screen
    my $dbh = FB::DB->db_Main();
    if ($form->has_submission_database($dbh) == 0) {
        $self->page->{'message'}
            .= "The form you selected is not saving data to a database.";
        $self->manage();
    }
    
    # We need to use id in lowercase rather than ID because of Excel's bug
    # Excel interprets any text file starting with ID as a SYLK file and
    # fails if someone tries to open a CSV file into Excel
    # http://support.microsoft.com/kb/323626
    my @field_labels = ("id", "Submitted By", "Date Submitted");
    my @field_names  = qw/submission_id remote_user date_submitted/;
    
    foreach my $node ($form->nodes) {
        next unless $node->can_be_submitted;
        if ($node->can_have_elements) {
            foreach my $element ($node->elements) {
                push (@field_labels, $node->label . ":" . $element->label);
                push (@field_names,  $element->name);
            }
        }
        else {
            push (@field_labels, $node->label);
            push (@field_names,  $node->name);
        }
    }

    my $filename = "data.csv";
    
    print "Content-type: text/csv\n";
    # The Content-Disposition will generate a prompt to save the file. If you want
    # to stream the file to the browser, comment out the following line.
    print "Content-Disposition: attachment; filename=$filename\n";
    print "\n";
    
    # print headers
    $csv->combine(@field_labels);
    print $csv->string . "\n";

    my $statement
        = "SELECT " 
         . join(',', @field_names) 
         . " FROM "
         . "form_" . $form->id . ".submission"
         . " ORDER BY submission_id DESC;"
         ;
         
    my $sth = $dbh->prepare($statement);
    $sth->execute;
    
    # loop through the data
    while ( my $array_ref = $sth->fetchrow_arrayref ) {
        $csv->combine(@{$array_ref});
        print $csv->string . "\n";        
    }

    exit;
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

sub export_entries_as_excel {
    my $self = shift;
    my $form = $self->form;

    use Spreadsheet::WriteExcel;

    # Check if there is, in fact, a submissions database. If there isn't one,
    # send the user back to the Form Management Screen
    my $dbh = FB::DB->db_Main();
    if ($form->has_submission_database($dbh) == 0) {
        $self->page->{'message'}
            .= "The form you selected is not saving data to a database.";
        $self->manage();
    }
    
    my @field_labels = ("ID", "Submitted By", "Date Submitted");
    my @field_names  = qw/submission_id remote_user date_submitted/;
    
    foreach my $node ($form->nodes) {
        next unless $node->can_be_submitted;
        if ($node->can_have_elements) {
            foreach my $element ($node->elements) {
                push (@field_labels, $node->label . ":" . $element->label);
                push (@field_names,  $element->name);
            }
        }
        else {
            push (@field_labels, $node->label);
            push (@field_names,  $node->name);
        }
    }

    my $filename = "data.xls";

    print "Content-type: application/vnd.ms-excel\n";
    # The Content-Disposition will generate a prompt to save the file. If you want
    # to stream the file to the browser, comment out the following line.
    print "Content-Disposition: attachment; filename=$filename\n";
    print "\n";
    
    # Create a new workbook and add a worksheet.
    # The special Perl filehandle - will redirect the output to STDOUT
    my $workbook = Spreadsheet::WriteExcel->new('-');
    
    my $headers  = $workbook->add_format();
    $headers->set_bold();
    $headers->set_size(10);
    $headers->set_text_wrap();
    
    my $values  = $workbook->add_format();
    $values->set_size(10);
    $values->set_text_wrap();
    $values->set_align('top');
    

    my $work_sheet = $workbook->addworksheet("Submissions");
    
    $work_sheet->set_column(0, $#field_labels, 20);    
    $work_sheet->write(0,0,\@field_labels,$headers);
    
    
    my $statement
        = "SELECT " 
         . join(',', @field_names) 
         . " FROM "
         . "form_" . $form->id . ".submission"
         . " ORDER BY submission_id DESC;"
         ;
         
    my $sth = $dbh->prepare($statement);
    $sth->execute;
    
    my $i = 1;
    while ( my $array_ref = $sth->fetchrow_arrayref ) {
        $work_sheet->write_row($i,0,$array_ref,$values);
        $i++;
    }
    
    $workbook->close();

    exit;
}

sub download_spreadsheet {
  my ($spreadsheet_location, $filename) = @_;
  open REPORT, "$spreadsheet_location";
  
#  print "Pragma: no-cache\n";
  print "Content-type: Application/Octet-stream\nContent-disposition: attachment; filename=\"$filename\" \n\n";
  
  binmode REPORT;
  my $buffer = "";
  while (read (REPORT, $buffer, 16_384)){
    print $buffer;
  } 
  close REPORT;
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

sub edit_form {
    my $self = shift;
    my $html_output = "";
    
    my $form = $self->form;
    my @optional = ();
    my @required = ();

    if  ($form->nodes) {
        foreach my $node (@{$form->nodes}) {
            if ($node->is_required) {
                push (@required, $node->name);
            }
            else {
                push (@optional, $node->name);
            }
        }
    }
            
    my $template = Template->new({
        INCLUDE_PATH => $self->templates_path
    });
    
    
    $template->process(
        'formbuilder.tt',
        { user   => $self->user,
          form   => $self->form,
          page   => $self->page,
          input  => $self->node,
          values => $self->values,
        },
        \$html_output
    ) or die $template->error();
    
    print $self->cgi->header;
    print $html_output;
    exit;
}

##############################################################################
# Usage       : $fb->duplicate_form
# Purpose     : Duplicates an existing form
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking

sub duplicate_form {
  my $self = shift;
  my $form = $self->form;
  print $self->cgi->header;
  use Data::Dumper;
  print Dumper $form;
  exit;
}

##############################################################################
# Usage       : $fb->confirm_delete_form
# Purpose     : Prints the delete form confirmation page
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking

sub confirm_delete_form {
    my $self = shift;
    my $user = $self->user;
    my $form = $self->form;
    
    # in Stanford's case, the identifier is the SUNET_ID
    # find the user with this SUNET_ID        
    my $html_output = "";
    my $template = Template->new({
        INCLUDE_PATH => $self->templates_path
    });
    
    $template->process(
        'confirm_delete_form.tt',
        { user => $user, page => $self->page, form => $form },
        \$html_output
    ) or die $template->error();
    
    print $self->cgi->header;
    print $html_output;
    exit;
}

##############################################################################
# Usage       : $fb->delete_form
# Purpose     : Prints the delete form confirmation page
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking

sub delete_form {
    my $self = shift;
    my $user = $self->user;
    my $form = $self->form;
        
    # Don't really delete the form, set it to deleted and save that.
    $form->set_to_deleted($user->identifier);

    # Remove this form from the list for this user (but in memory only)
    $user->remove_form($form);
    
    $self->page->{'message'} = "Success! The form has been deleted.";
    $self->manage;
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

sub create_new_form {
    my $self = shift;
    my $user = $self->user;
    my $form;
    
    # Retrieve the maximum number of forms for this user
    my $max_forms = $user->max_forms;

    # Retrieve the number of forms this user created
    my $total_forms = scalar @{$user->forms};

    if ($total_forms < $max_forms) {
        # Create a new form and then store it
        $form
            = FB::Form->new(
                creator             => $user->identifier,
                submission_email    => $user->email,
                css                 => 'stanford',
            );

        $form->store();
        
        # Make the newly created form the one we are working on
        $self->set_form($form);

        # Make the user the owner of this form
        $user->add_form($form, 'creator');
        
        # Print the new page notice
        $self->page->{'notices'}{'new_form'} = 1;
        
        # Start at Edit
        $self->page->{'tab_number'} = EDIT_TAB;

        # Show the form's properties
        $self->page->{'show_form_properties'} = 1;
    }
    else {
        $self->page->{'message'}
            = "You've already reached the maximum number "
            . "of forms.";
        $self->manage();
    }
    
    $self->values->{'form'}{'name'} = $self->form->name;
    $self->values->{'form'}{'description'} = $self->form->description;
}


##############################################################################
# Usage       : $self->move_node_up
# Purpose     : Move a node up the list by calling the form's own function
#               and passing it the value we got from the user
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
    # What if the node position is not a number?
    # What if the node is not a number within the number of nodes?
    # What if storing of the form fails?
# TODO: Testing Code

sub move_node_up {
    my $self = shift;
    my $node_position = $self->cgi->param('node_position');
    $self->form->move_node_up($node_position);
    $self->page->{'tab_number'} = BUILD_TAB;
    $self->form->store();
}


##############################################################################
# Usage       : $self->move_node_down
# Purpose     : Move a node down the list by calling the form's own function
#               and passing it the value we got from the user
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub move_node_down {
    my $self = shift;
    my $node_position = $self->cgi->param('node_position');
    $self->form->move_node_down($node_position);
    $self->page->{'tab_number'} = BUILD_TAB;
    $self->form->store();
}

##############################################################################
# Usage       : $self->delete_node
# Purpose     : Delete a node from a list by calling the form's own function
#               and passing it the value we got from the user
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub delete_node {
    my $self = shift;
    
    my $node_position = $self->cgi->param('node_position');
    my $node_id       = $self->cgi->param('node_id');
    
    $self->form->remove_node_at($node_position, $node_id);
    
    $self->form->store();

    # Return the user to the build tab since there is nothing to edit
    $self->page->{'tab_number'} = BUILD_TAB;
    $self->page->{'confirmations'}{'build'}{'header'}
        = "Update Was Successful";
    $self->page->{'confirmations'}{'build'}{'message'}
        = "The field was deleted.";
}


##############################################################################
# Usage       : $self->edit_node
# Purpose     : Loads information about a node and then displays the edit
#				interface.
# Returns     : ????
# Parameters  : none directly, but we use the node position on the form to
#				find the node in question.
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub edit_node {
    my $self = shift;
    my $node_position = $self->cgi->param('node_position');
    $self->set_node($self->form->get_node_at($node_position));
    $self->page->{'node_position'} = $node_position;
    $self->page->{'tab_number'} = EDIT_TAB;
    $self->page->{'show_node_properties'} = 1;
    $self->values->{'input'} = $self->node;
	$self->fill_element_values;
    $self->fill_item_values;
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

sub add_node {
    my $self = shift;
    my $node_type = $self->cgi->param('node_type');
    my $class = FB->get_class_from_type($node_type);

    # Add the node to the form
    my $node_position = $self->form->add_node($class->new());
   
    # Keep track of which node we are working on
    $self->set_node($self->form->get_node_at($node_position));

    # Write changes to the database
    $self->form->store();
    
    $self->page->{'confirmations'}{'new_node_added'} = 1;
    $self->page->{'node_position'} = $node_position;
    $self->page->{'tab_number'} = EDIT_TAB;
    $self->page->{'show_node_properties'} = 1;

    # TODO: Add the node properties to the values
    $self->values->{'input'} = $self->node;
    $self->fill_element_values;
    $self->fill_item_values;
}

sub fill_item_values {
    my $self = shift;
    my $node = $self->node;
    if (!$node->can_have_items || $node->is_custom) {
        return;
    }

    my @items = @{$node->items};
    if ($#items >= 0) {
        foreach my $item (@items) {
            $self->values->{'input'}{$item->id . "_item_sort_order"}
                = $item->sort_order + 1;
            $self->values->{'input'}{$item->id . "_item_value"}
                = $item->value;

        }
    }
}

sub fill_element_values {
    my $self = shift;
    my $node = $self->node;

    # don't do anything if the node can't have elements or
	# if it's a custom node (where elements are not updated by users
    if (!$node->can_have_elements || $node->is_custom) {
        return;
    }

    my @elements = @{$node->elements};

    my $element_sort_order = 1;
    if ($#elements >= 0) {
        foreach my $element (@elements) {
            $self->values->{'input'}{$element->id . "_element_sort_order"}
                = $element_sort_order++;
            $self->values->{'input'}{$element->id . "_element_value"}
                = $element->label;

        }
    }

	# we also fill in information about the first element
	# TODO: what if there is no first element?
	my $first_element = $elements[0];
    my @items = @{$first_element->items};
    if ($#items >= 0) {
        foreach my $item (@items) {
            $self->values->{'input'}{'first_element'}{$item->id . "_item_sort_order"}
                = $item->sort_order + 1;
            $self->values->{'input'}{'first_element'}{$item->id . "_item_value"}
                = $item->value;

        }
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
# TODO: Testing Code

sub edit_form_properties {
    my $self = shift;
    $self->values->{'form'}{'name'} = $self->form->name;
    $self->values->{'form'}{'description'} = $self->form->description;
    $self->page->{'tab_number'} = EDIT_TAB;
    $self->page->{'show_form_properties'} = 1;
}


##############################################################################
# Usage       : $self->save_form_properties();
# Purpose     : Check the validity of paramenters, and if all looks OK, save
#               the form's properties to the database
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub save_form_properties {
    my $self = shift;
    my $cgi  = $self->cgi;
    my $form = $self->form;
    
    my @form_fields = qw/name description/;
    
    # get a hash reference for the parameters and the original values
    # since we didn't save anything, we want to keep the user's entered
    # values rather than print out the value in the database
    my %submitted_values = %{$cgi->Vars};
    
    my $validation_profile = {
        # Optional fields that are left empty are considered valid
        missing_optional_valid => 1,

        # Trim white space from the beginning and end of values before
        # the value is checked for constraints
        filters  => [qw( trim )],
        
        # The following are fields marked as required
        required => [qw( name )],

        # The following are the option fields
        optional => [qw( description )],
        
        # Set some properties for the messages to be returned.
        msgs => {
            # this prefix is used later, in the template
            prefix => 'error_',
            # the message to display when a field is missing
            missing => 'Please fill in the following:',
            # we handle the formatting through CSS
            format => '%s',
        },
    };
    
    my $results = Data::FormValidator->check($cgi, $validation_profile);
    
    # If everything went well, save all values, store the form, set a success
    # message and return the values as saved in the form
    if ($results->success) {
        
        # Update the form's values based on what was passed by the user
        foreach my $field (@form_fields) {
            my $setter = "set_" . $field;
            $form->$setter($results->valid($field));
        }

        # Store the form into the database
        $form->store;
        
        # Update the template's values with those now saved in the form
        # We don't pass the valid form so the user will see exactly what's
        # been saved
        foreach my $field (@form_fields) {
            $self->values->{'form'}{$field} = $form->$field;
        }
        
        # Set the success message
        $self->page->{'confirmations'}{'edit'}{'header'} .= "Success";
        $self->page->{'confirmations'}{'edit'}{'message'}
            .= "The form's properties have been updated.";
    }
    else {
        # Update the template's values with those just passed by the user
        # We do this to keep state and not delete the user's entries
        # when there is a mistake on some part of the form
        foreach my $field (@form_fields) {
            $self->values->{'form'}{$field} = $submitted_values{$field};
        }
        
        # Set the error message
        $self->page->{'errors'}{'edit'}{'header'} .= "Error";
        $self->page->{'errors'}{'edit'}{'message'}
            .= "Your changes were not saved. There were some errors.<br />"
            . "Please see below.";

        # Pass the individual error messages (e.g. this is missing,
        # that is invalid) to the template
        my %error_messages = %{$results->msgs};
        foreach (keys %error_messages) {
            $self->page->{$_} = $error_messages{$_};
        }
    }
    
    #my $theme = $cgi->param('theme');

    my $total_number_of_nodes = scalar @{$form->nodes};
#    $self->page->{'edit_notice'} = 1;
#    $self->page->{'edit_notice_header'} = "Update Was Successful";
#    $self->page->{'edit_notice_message'} = "The form has been updated.";
    unless ($total_number_of_nodes) { $self->page->{'confirmations'}{'edit'}{'message'} .= "<br />Now, you can add some fields by going to the BUILD tab above.";
    }

    $self->page->{'tab_number'} = EDIT_TAB;
    $self->page->{'show_form_properties'} = 1;
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

sub save_field_properties {
    my $self = shift;
    my $cgi = $self->cgi;
    my $form = $self->form;
    
    my $node_position = $cgi->param('node_position');
    $self->set_node($self->form->get_node_at($node_position));
    my $node = $self->node;
    
    # All fields have a label, but only some can be required and
    # even fewer can have a value that can be set in the formbuilder
    my @field_properties = qw/label/;
    my @item_fields = qw/new_item_value/;
    my @element_fields = qw/new_element_value/;
    my @required_fields = qw/label/;
    my @optional_fields;
    my %require_some;
    my %constraint_methods;
    my %defaults;
    
    if ($node->can_be_required) {
        push (@field_properties, 'is_required');
        push (@optional_fields, 'is_required');
        $defaults{'is_required'} = 0;
    }

    if ($node->can_be_autofilled) {
        push (@field_properties, 'is_autofilled');
        push (@optional_fields, 'is_autofilled');
        $defaults{'is_autofilled'} = 0;
    }
    
    if ($node->can_have_value) {
        push (@field_properties, 'value');
        push (@optional_fields, 'value');
    }
    
    if ($node->can_have_items && !$node->is_custom) {
        #TODO: is this a custom itemset?
        my @items = @{$self->node->items};
        
        if ($#items >= 0) {
            foreach my $item (@items) {
                push (@optional_fields, "delete_item_" . $item->id);
                push (@optional_fields, $item->id . "_item_value");
                push (@optional_fields, $item->id . "_item_sort_order");
                push (@item_fields, "delete_item_" . $item->id);
                push (@item_fields, $item->id . "_item_value");
                push (@item_fields, $item->id . "_item_sort_order");
                $require_some{$item->id . "_item_value"}
                    = [ $item->id . "_item_value", 
                        "delete_item_" . $item->id
                      ];
                $require_some{$item->id . "_item_sort_order"}
                    = [ $item->id . "_item_sort_order", 
                        "delete_item_" . $item->id
                      ];
                $constraint_methods{$item->id . "_item_sort_order"}
                    = FV_num_int(-keep => $3);
            }
        }
    }

    if ($node->can_have_elements && !$node->is_custom) {
        my @elements = @{$self->node->elements};

        if ($#elements >= 0) {
            foreach my $element (@elements) {
                push (@optional_fields, "delete_element_" . $element->id);
                push (@optional_fields, $element->id . "_element_value");
                push (@optional_fields, $element->id . "_element_sort_order");
                push (@element_fields, "delete_element_" . $element->id);
                push (@element_fields, $element->id . "_element_value");
                push (@element_fields, $element->id . "_element_sort_order");
                $require_some{$element->id . "_element_value"}
                    = [ $element->id . "_element_value",
                        "delete_element_" . $element->id
                      ];
                $require_some{$element->id . "_element_sort_order"}
                    = [ $element->id . "_element_sort_order",
                        "delete_element_" . $element->id
                      ];
                $constraint_methods{$element->id . "_element_sort_order"}
                    = FV_num_int(-keep => $3);
            }
        }

		# add validation for the itemset
		my $first_element = $elements[0];
		
        my @items = @{$first_element->items};
        
        if ($#items >= 0) {
            foreach my $item (@items) {
                push (@optional_fields, "delete_item_" . $item->id);
                push (@optional_fields, $item->id . "_item_value");
                push (@optional_fields, $item->id . "_item_sort_order");
                push (@item_fields, "delete_item_" . $item->id);
                push (@item_fields, $item->id . "_item_value");
                push (@item_fields, $item->id . "_item_sort_order");
                $require_some{$item->id . "_item_value"}
                    = [ $item->id . "_item_value", 
                        "delete_item_" . $item->id
                      ];
                $require_some{$item->id . "_item_sort_order"}
                    = [ $item->id . "_item_sort_order", 
                        "delete_item_" . $item->id
                      ];
                $constraint_methods{$item->id . "_item_sort_order"}
                    = FV_num_int(-keep => $3);
            }
        }
	}

    
    
    # get a hash reference for the parameters and the original values
    # since we didn't save anything, we want to keep the user's entered
    # values rather than print out the value in the database
    my %submitted_values = %{$cgi->Vars};
    
    my $validation_profile = {

        # Optional fields that are left empty are considered valid
        missing_optional_valid => 1,

        # Trim white space from the beginning and end of values before
        # the value is checked for constraints
        filters  => [qw( trim )],
                
        # The label is always required
        required => [@required_fields],

        # The value and the is_required and is_autofilled are optional
        optional => [@optional_fields],
        
        # This is a list of possible defaults
        defaults => \%defaults,
        
        
        # Set some properties 
        msgs => {
            # this prefix is used later, in the template
            prefix => 'error_',
            # the message to display when a field is missing
            missing => 'Please fill in the following:',
            # we handle the formatting through CSS
            format => '%s',
        },
        
        require_some => \%require_some,
        constraint_methods => \%constraint_methods,
    };

    my $results = Data::FormValidator->check($cgi, $validation_profile);

    # If everything went well, save all values, store the form, set a success
    # message and return the values as saved in the form
    if ($results->success) {
        
        # Update the form's values based on what was passed by the user
        foreach my $field (@field_properties) {
            my $setter = "set_" . $field;
            $node->$setter($results->valid($field));
        }
        
        if ($node->can_have_elements && !$node->is_custom) {
            my @elements = @{$self->node->elements};
            
            if ($#elements >= 0) {
                foreach my $element (@elements) {
                    
                    # If the element is to be deleted, we do that first
                    # and not worry about any other action on it
                    if ($cgi->param("delete_element_" . $element->id)) {
                        my $element_position = $element->sort_order($node->id);
                        my $removed_element
                            = $node->remove_element_at($element_position);
                        next;
                    }
                    
                    # We now update the label for every element
                    my $element_value = $cgi->param($element->id . "_element_value");
                    if (defined $element_value) {
                        $element_value = trim($element_value);
                        $element->set_label($element_value);
                    }
                    
                    # We now set the new temporary sort_order for these elements
                    my $element_sort_order
                        = $cgi->param($element->id . "_element_sort_order");
                    if (defined $element_sort_order) {
                        $element_sort_order = trim($element_sort_order);
                        $element->set_sort_order($node->id, $element_sort_order);
                    }
                }
            }
            
            # We now resort the elements in case any of the sort orders have been
            # changed
            $node->resort_elements();
            
            # Was a new element added?
            # Note that right now we are only using this for a particular type
            # of collection which always has identical items within the element
            # (i.e. likert)
            
            my $new_element_value = $cgi->param('new_element_value');
            
            if (defined $new_element_value) {
                $new_element_value = trim($new_element_value);
            }
            else {
                $new_element_value = "";
            }

            if ($new_element_value ne "") {
                # if we have elements in this collection, and
                # this collection is not using unique elements
                # copy the first and update the label only
                my @remaining_elements = @{$self->node->elements};
                my $new_element;
                if ($#remaining_elements >= 0) {
                    $new_element = $remaining_elements[0]->copy;
                    $new_element->set_label($new_element_value);
                }
                else {
                    $new_element
                        = FB::Form::Element::Select::LikertItem->new(
                            class => "likert_item",
                            label => $new_element_value,
                        );                    
                }
                
                $node->add_element($new_element);
            }
			
			my $first_element = $node->elements->[0];
			my @items = @{$first_element->items};
			
            if ($#items >= 0) {
                foreach my $item (@items) {

                    # If the item is to be deleted, we do that first
                    # and not worry about any other action on this
                    # option item
                    if ($cgi->param("delete_item_" . $item->id)) {
                        my $item_position = $item->sort_order;
                        my $removed_option
                            = $first_element->remove_item_at($item_position);
                        next;
                    }

                    # We now update the value for every item
                    my $item_value = $cgi->param($item->id . "_item_value");
                    if (defined $item_value) {
                        $item_value = trim($item_value);
                        $item->set_label($item_value);
                        $item->set_value($item_value);
                    }

                    # We now set the new temporary sort_order for these items
                    my $item_sort_order
                        = $cgi->param($item->id . "_item_sort_order");
                    if (defined $item_sort_order) {
                        $item_sort_order = trim($item_sort_order);
                        $item->set_sort_order($item_sort_order);
                    }
                }
            }

            # We now resort the items in case any of the sort orders have been
            # changed
            $first_element->resort_items();

            # Was a new item added?
            my $new_item_value = $cgi->param('new_item_value');
            if (defined $new_item_value) {
                $new_item_value = trim($new_item_value);
            }
            else {
                $new_item_value = "";
            }

            if ($new_item_value ne "") {

                # Create a new option item using the new value and add it to
                # the node
                my $new_option
                    = FB::Form::Element::Select::Item->new(
                        label => $new_item_value,
                        value => $new_item_value,
                    );
                $first_element->add_item($new_option);
            }
            
			foreach my $element ($node->elements) {
				$element->set_itemset($first_element->itemset);
			}
			
        } # end of $node->can_have_elements
        
        if ($node->can_have_items && !$node->is_custom) {
            #TODO: is this a custom itemset?
            my @items = @{$self->node->items};

            if ($#items >= 0) {
                foreach my $item (@items) {

                    # If the item is to be deleted, we do that first
                    # and not worry about any other action on this
                    # option item
                    if ($cgi->param("delete_item_" . $item->id)) {
                        my $item_position = $item->sort_order;
                        my $removed_option
                            = $node->remove_item_at($item_position);
                        next;
                    }

                    # We now update the value for every item
                    my $item_value = $cgi->param($item->id . "_item_value");
                    if (defined $item_value) {
                        $item_value = trim($item_value);
                        $item->set_label($item_value);
                        $item->set_value($item_value);
                    }

                    # We now set the new temporary sort_order for these items
                    my $item_sort_order
                        = $cgi->param($item->id . "_item_sort_order");
                    if (defined $item_sort_order) {
                        $item_sort_order = trim($item_sort_order);
                        $item->set_sort_order($item_sort_order);
                    }
                }
            }

            # We now resort the items in case any of the sort orders have been
            # changed
            $node->resort_items();

            # Was a new option added?
            my $new_item_value = $cgi->param('new_item_value');
            if (defined $new_item_value) {
                $new_item_value = trim($new_item_value);
            }
            else {
                $new_item_value = "";
            }

            if ($new_item_value ne "") {

                # Create a new option item using the new value and add it to
                # the node
                my $new_option
                    = FB::Form::Element::Select::Item->new(
                        label => $new_item_value,
                        value => $new_item_value,
                    );
                $node->add_item($new_option);
            }
            
        } # end of $node->can_have_items

        # Store the node into the database
        $node->store;
        
        
        $self->fill_item_values;
        $self->fill_element_values;
        
        
        # Update the template's values with those now saved in the form
        # We don't pass the valid form so the user will see exactly what's
        # been saved
        foreach my $field (@field_properties) {
            $self->values->{'input'}{$field} = $node->$field;
        }
        
        # Set the success message
        $self->page->{'confirmations'}{'edit'}{'header'} .= "Success";
        $self->page->{'confirmations'}{'edit'}{'message'}
            .= "The field's properties have been updated";
    }
    else {
        # Update the template's values with those just passed by the user
        # We do this to keep state and not delete the user's entries
        # when there is a mistake on some part of the form
        foreach my $field (@field_properties) {
            $self->values->{'input'}{$field} = $submitted_values{$field};
        }

		# if this is a node that can have elements, it will need to have the
		# item fields stored in a different location, under "first_element"
	    if ($node->can_have_elements && !$node->is_custom) {
	        foreach my $field (@item_fields) {
	            $self->values->{'input'}{'first_element'}{$field} = $submitted_values{$field};
	        }
		}
		else {
	        foreach my $field (@item_fields) {
	            $self->values->{'input'}{$field} = $submitted_values{$field};
	        }			
		}

        foreach my $field (@element_fields) {
            $self->values->{'input'}{$field} = $submitted_values{$field};
        }
        
        # Set the error message
        $self->page->{'errors'}{'edit'}{'header'} .= "Error";
        $self->page->{'errors'}{'edit'}{'message'}
            .= "Your changes were not saved. There were some errors.<br />"
            . "Please see below.";

        # Pass the individual error messages (e.g. this is missing,
        # that is invalid) to the template
        my %error_messages = %{$results->msgs};
        foreach (keys %error_messages) {
            $self->page->{$_} = $error_messages{$_};
        }
    }

#    $self->page->{'confirmations'}{'edit'}{'header'}
#        .= "Update Was Successful";
#    $self->page->{'confirmations'}{'edit'}{'message'}
#        .= "The field has been updated.";


    $self->page->{'node_position'} = $node_position;
    $self->page->{'tab_number'} = EDIT_TAB;
    $self->page->{'show_node_properties'} = 1;
}

##############################################################################
## Usage       : $self->add_form_by_url();
## Purpose     : Check the validity of paramenters, and if all looks OK, add
##               this user to the form admins
## Returns     : ????
## Parameters  : none
## Throws      : no exceptions
## Comments    : none
## See Also    : n/a
#
## TODO: Error Checking
## TODO: Testing Code

sub add_form_by_url {
    my $self = shift;
    my $cgi  = $self->cgi;

# we don't have a form yet
#my $form = $self->form;

    my @form_fields = qw/form_url/;

    # get a hash reference for the parameters and the original values
    # since we didn't save anything, we want to keep the user's entered
    # values rather than print out the value in the database
    my %submitted_values = %{$cgi->Vars};

    my $validation_profile = {

        # Optional fields that are left empty are considered valid
        missing_optional_valid => 1,

        # Trim white space from the beginning and end of values before
        # the value is checked for constraints
        filters  => [qw( trim )],

        # The following are fields marked as required
        required => [qw( form_url )],

        # The following are the option fields
        optional => [],

        # Some fields (whether optional or not) need to pass tests before
        # they can be considered valid
        constraint_methods => {
            form_url => [
                FV_URI_HTTP(-scheme => qr/https?/),
                dfv_add_url_check($self),
            ],
        },

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
                'FV_URI_HTTP' => 'Not a valid URL format.',
                'dfv_form_name_check' => 'The form name is not valid.',
                'dfv_host_name_check' => 'This service supports only forms hosted on the main www.stanford.edu servers. (This includes those going through vanity URLs, although at the moment you need to use the www.stanford.edu URL in this form.)',
                'dfv_directory_exists_check' => 'The form URL you have entered maps to an AFS path that does not exist.',
                'dfv_user_can_admin_check' => 'The form URL you have entered maps to an AFS path for which you are not an administrator.',
                'dfv_form_not_found' => 'Cannot find a form at that URL.',
                'dfv_user_can_edit_form' => 'You can already edit the form.',
            },
        },
    };

    my $results = Data::FormValidator->check($cgi, $validation_profile);

    if ($results->success) { 
        my $form_url = trim($self->cgi->param('form_url'));
        my $form = FB::Form->new_from_path(url_to_file($form_url)); 
        $self->user->add_form($form, 'admin');
        #$self->user->reload_forms();
        $self->page->{'message'} = "The form has been added. You should now see it in the My Forms list.";
    }
    else {
        # Update the template's values with those just passed by the user
        # We do this to keep state and not delete the user's entries
        # when there is a mistake on some part of the form
        $self->page->{'form_url'} = $submitted_values{'form_url'};

        # Set the error message
        $self->page->{'message'} = "There were some errors. Please see below.";

        # Pass the individual error messages (e.g. this is missing,
        # that is invalid) to the template
        my %error_messages = %{$results->msgs};
        foreach (keys %error_messages) {
            $self->page->{$_} = $error_messages{$_};
        }
    }

    # figure out what AFS path that URL corresponds to
    # throw a suggestion if the URL is not www.stanford.edu?
    # figure out the AFS directory
    # check to see if the user has admin access to that directory
    # if the user has admin access, add them as admins to that form
    # if the user does not have admin access, return a message and do nothing
    # Report to the creator that an admin was added?
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

sub dfv_add_url_check {
    my $self = shift;
    return sub {
        my $dfv = shift;
        my $url = $dfv->get_current_constraint_value();

        # At this point, we know it's a valid URL
        # according to Regexp::Common

        # We first do a check to see if the form name
        # is there and it's in the correct format
        if (!form_name_check($url)) {
            $dfv->name_this('dfv_form_name_check');
            return 0;
        }

        # Now, we check to see if the host name is OK
        if (!$self->host_name_check($url)) {
            $dfv->name_this('dfv_host_name_check');
            return 0;
        }

        # Take the URL and retrieve the filepath
        # and form name
        my ($url_base, $form_name) = url_split($url);

        # Translate the URL into a file path
        my $file_path = url_to_file($url_base);
        my $user = $self->user->identifier;

        # Make sure the directory exists
        my $retval;
        eval {
            $retval = remctl('lsdb', 'afsdir', 'chkexist', $file_path);
        };
        if ($@) {
            $dfv->name_this('dfv_directory_exists_check');
            return 0;
        }
        else {
            if ($retval ne "0") {
                $dfv->name_this('dfv_directory_exists_check');
                return 0;
            }
        }

        # Make sure the user can administer this path
        eval {
            $retval = remctl('lsdb', 'afsdir', 'chkadmin', $file_path, $user);
        };
        if ($@) {
            $dfv->name_this('dfv_user_can_admin_check');
            return 0;
        }
        else {
            if ($retval ne "0") {
                $dfv->name_this('dfv_user_can_admin_check');
                return 0;
            }
        }

        # Does a form exist at this path?
        my $full_path = url_to_file($url);
        my $form = FB::Form->new_from_path($full_path);
        unless (defined($form)) { 
          $dfv->name_this('dfv_form_not_found');
          return 0; 
        } 

        # Is the user already able to administer this form?
        if ($self->user->can_edit($form)) {
          $dfv->name_this('dfv_user_can_edit_form');
          return 0; 
        }
        
        return 1;
    }
}

##############################################################################
# Usage       : $self->save_publishing_settings();
# Purpose     : Check the validity of paramenters, and if all looks OK, save
#               the form's publishing settings to the database
# Returns     : ????
# Parameters  : none
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub save_publishing_settings {    
    my $self = shift;
    my $cgi  = $self->cgi;
    my $form = $self->form;
    
    my %confirmation_values = (
        'text'  => 1,
        'url'   => 1,
    );
    
    my @form_fields = qw/confirmation_method 
                         confirmation_text
                         confirmation_url
                         submission_method
                         submission_email
                         submission_email_subject
                         url
                         is_live
                        /;

    # get a hash reference for the parameters and the original values
    # since we didn't save anything, we want to keep the user's entered
    # values rather than print out the value in the database
    my %submitted_values = %{$cgi->Vars};
    
    # The following is a Data::FormValidator validation profile that 
    # determines what makes a form "valid", in this case the form used to
    # update a form's publishing settings

    my $validation_profile = {

        # Optional fields that are left empty are considered valid
        missing_optional_valid => 1,

        # Trim white space from the beginning and end of values before
        # the value is checked for constraints
        filters  => [qw( trim )],
        
        # The following are fields marked as required
        required => [qw( confirmation_method
                         submission_method
                         is_live )
                    ],
        # The following are the option fields
        optional => [qw( submission_email
                         submission_email_subject
                         confirmation_text
                         confirmation_url
                         url
                    )],
        
        # Detail the dependencies between fields. Regularly optional
        # fields become required based on the values of other fields
        dependencies => {
            confirmation_method => {
                url => [ qw( confirmation_url ) ],
                text => [ qw( confirmation_text ) ],
            },
            submission_method => {
                both => [ qw ( submission_email submission_email_subject ) ],
                email => [ qw ( submission_email submission_email_subject ) ],
            },
            is_live => {
                1 => [ qw (url) ],
            }
        },
        
        # Some fields (whether optional or not) need to pass tests before
        # they can be considered valid
        constraint_methods => {
            submission_email => email(),
            url => [
                FV_URI_HTTP(-scheme => qr/https?/),
                dfv_url_check($self),
            ],
            confirmation_url => FV_URI_HTTP(-scheme => qr/https?/),
            confirmation_method =>
                sub { my $val = pop; return $confirmation_values{$val}; }
        },
        
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
                'email' => 'Not a valid email format.',
                'FV_URI_HTTP' => 'Not a valid URL format.',
                'dfv_form_name_check' => 'The form name is not valid.',
                'dfv_host_name_check' => 'This service supports only forms hosted on the main www.stanford.edu servers. (This includes those going through vanity URLs, although at the moment you need to use the www.stanford.edu URL in this form.)',
                'dfv_directory_exists_check' => 'The form URL you have entered maps to an AFS path that does not exist.',
                'dfv_user_can_write_check' => 'The form URL you have entered maps to an AFS path to which you cannot write.',
                'dfv_unique_path_check' => 'The form URL you have entered maps to an AFS path that is already in use by another form.',
                
                
            },
        },
    };
    my $results = Data::FormValidator->check($cgi, $validation_profile);

    # If everything went well, save all values, store the form, set a success
    # message and return the values as saved in the form
    if ($results->success) {
        
        # Update the form's values based on what was passed by the user
        foreach my $field (@form_fields) {
            # we skip is_live here, as it needs to check for path first
            next if $field eq "is_live";
            my $setter = "set_" . $field;
            $form->$setter($results->valid($field));
        }
        
        # Update the file path based on the URL
        my $url = $results->valid('url');
        if (defined $url) {
            if ($url eq "") {
                $form->set_path("");            
            }
            else {
                my ($base_url, $form_name) = url_split($url);
                my $file_path = url_to_file($base_url);
                $form->set_path("$file_path/$form_name");            
            }            
        }
        
        if (defined $results->valid('is_live')) {
            $form->set_is_live($results->valid('is_live'));
        }

        # Store the form into the database
        $form->store;
        
        # Update the template's values with those now saved in the form
        # We don't pass the valid form so the user will see exactly what's
        # been saved
        foreach my $field (@form_fields) {
            $self->values->{'form'}{$field} = $form->$field;
        }
        
        # Set the success message
        $self->page->{'confirmations'}{'publishing'}{'header'} .= "Success";
        $self->page->{'confirmations'}{'publishing'}{'message'}
            .= "The form's publishing settings have been updated.";
    }
    else {
        # Update the template's values with those just passed by the user
        # We do this to keep state and not delete the user's entries
        # when there is a mistake on some part of the form
        foreach my $field (@form_fields) {
            $self->values->{'form'}{$field} = $submitted_values{$field};
        }
        
        # Set the error message
        $self->page->{'errors'}{'publishing'}{'header'} .= "Error";
        $self->page->{'errors'}{'publishing'}{'message'}
            .= "Your changes were not saved. There were some errors.<br />"
            . "Please see below.";

        # Pass the individual error messages (e.g. this is missing,
        # that is invalid) to the template
        my %error_messages = %{$results->msgs};
        foreach (keys %error_messages) {
            $self->page->{$_} = $error_messages{$_};
        }
    }
    $self->page->{'tab_number'} = PUBLISH_TAB;
}

sub fill_publishing_settings {
    my $self = shift;
    my @form_fields = qw/confirmation_method 
                         confirmation_text
                         confirmation_url
                         submission_method
                         submission_email
                         submission_email_subject
                         url
                         is_live
                        /;

    foreach my $field (@form_fields) {
        $self->values->{'form'}{$field} = $self->form->$field;
    }
    
}
 
sub display_error {
    my ($self, %args) = @_;
    my $user_header  = $args{user_header}  || '';
    my $user_message = $args{user_message} || '';
    my $error_message = $args{error_message};
    my $fatal         = $args{fatal};
    my $status        = exists $args{status} ? $args{status} : "200 OK",
    
    
    my $html_output = "";

    my $template = Template->new({
        INCLUDE_PATH => $self->templates_path
    });

    $template->process(
        'error/error.tt',
        { user_header => $user_header, 
          user_message => $user_message,
        },
        \$html_output
    ) or die $template->error();    
    print $self->cgi->header(-status => "$status");
    print $html_output;
    
    # send to log...
    if ((defined $fatal) && ($fatal eq "1")) {
        Carp::croak($error_message);        
    }
    exit;
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

sub dfv_url_check {
    my $self = shift;
    return sub {
        my $dfv = shift;
        my $url = $dfv->get_current_constraint_value();

        # At this point, we know it's a valid URL
        # according to Regexp::Common
    
        # We first do a check to see if the form name
        # is there and it's in the correct format
        if (!form_name_check($url)) {
            $dfv->name_this('dfv_form_name_check');
            return 0;            
        }

        # Now, we check to see if the host name is OK
        if (!$self->host_name_check($url)) {
            $dfv->name_this('dfv_host_name_check');
            return 0;
        }
    
        # Take the URL and retrieve the filepath
        # and form name
        my ($url_base, $form_name) = url_split($url);

        # Translate the URL into a file path
        my $file_path = url_to_file($url_base);

        my $user = $self->user->identifier;

        # Make sure the directory exists
        my $retval;
        eval {
            $retval = remctl('lsdb', 'afsdir', 'chkexist', $file_path);        
        };
        if ($@) {
            $dfv->name_this('dfv_directory_exists_check');
            return 0;            
        }
        else {
            if ($retval ne "0") {
                $dfv->name_this('dfv_directory_exists_check');
                return 0;
            }
        }

        
        # Make sure the user can write to this path
        eval {
            $retval = remctl('lsdb', 'afsdir', 'chkwrite', $file_path, $user);            
        };
        if ($@) {
            $dfv->name_this('dfv_user_can_write_check');
            return 0;            
        }
        else {
            if ($retval ne "0") {
                $dfv->name_this('dfv_user_can_write_check');
                return 0;
            }
        }
        
        # Make sure the file path is not already in use.
        # When people submit a URL for the form, this is translated into
        # a file path. We need to make sure that this path is not used by
        # any other form out there. We don't check the URL since several
        # URLs could point to the same path.
        # This check is done after we check if the user can write to the
        # path. It'd be cheaper to do it before, but that means someone
        # could use the formbuilder to check for the existence of forms
        # possibly behind authentication.
        
        my $full_path = "$file_path/$form_name";
        my $total_paths
            = FB::DB::Form->count_paths($full_path, $self->form->id);
        if ($total_paths > 0) {
            $dfv->name_this('dfv_unique_path_check');
            return 0;
        }
        
        # If we didn't return by now, all should be OK
        return 1;
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
# TODO: Testing Code

sub url_split {
    my $url = shift;
    if ($url =~ m#(.+)/([\w-]+\.fb)$#i) {
        return $1, $2;
    }
    else {
        Carp::croak("Couldn't split URL");
    }
    
}

##############################################################################
# Usage       : form_name_check($url)
# Purpose     : Check if a url contains a form with the correct name.
# Returns     : 1 or 0
# Parameters  : $url, a string containing a full URL
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub form_name_check {
    my ($url) = @_;
    
    # Does the URL provided end with a form name?
    # TODO: make "fb" a system-wide setting
    if ($url =~ m#(.+)/([\w-]+\.fb)$#i) {
        my $form_name = $2;
        my $rest = $1;
        return 1;
    } else {
        return 0;
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
# TODO: Testing Code

# This function assumes that this is a proper URL
# its purpose is to make sure it's a valid domain name within
# the organization

sub host_name_check {
	my $self = shift;
    my $url  = shift;
        
    # the domain name has to be www.stanford.edu
	my $domain_name = $self->domain_name;
    if ($url =~ m#^https?://$domain_name/(.+)$#) {

# this one lets vanity URLs in (TODO: implement)
#    if ($url =~ m#^https?://(.+)?stanford.edu/(.+)$#) {
        return 1;
    }
    else {
        return 0;
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
# TODO: Testing Code

sub url_to_file {
    my $url = shift;
    
    my ($base, $rest);
   
    if ($url =~ m#^https?://www.stanford.edu/(class|group|dept)/([^/]+)(/.+)?#i) {
        $base = "/afs/ir/" . $1 . '/' . $2;
        $rest = $3;
        # WWW or cgi-bin?
        if ( (defined $rest) && ($rest =~ m#cgi-bin(/?.+)?#)) {
            $base .= "/cgi-bin";
            $rest = $1;
        }
        else {
            $base .= "/WWW";
        }

    }
    elsif ($url =~ m#^https?://www.stanford.edu/services/([^/]+)(/.+)?#i)
    {
        $base = "/afs/ir/dist/web/services/" . $1;
        $rest = $2;
        # WWW or cgi-bin?
        if ( (defined $rest) && ($rest =~ m#cgi-bin(/?.+)?#)) {
            $base .= "/cgi-bin";
            $rest = $1;
        }
    }
    elsif ($url =~ m#^https?://www.stanford.edu/(people/|~)([^/]+)(/.+)?#i){
        my $first_letter = substr($2,0,1);
        my $second_letter = substr($2,1,1);
        $base = "/afs/ir/users/$first_letter/$second_letter/$2";
        $rest = $3;
        # WWW or cgi-bin?
        if ( (defined $rest) && ($rest =~ m#cgi-bin(/?.+)?#)) {
            $base .= "/cgi-bin";
            $rest = $1;
        }
        else {
            $base .= "/WWW";
        }
    }
    elsif ($url =~ m#^https?://www.stanford.edu(/.+)?#i) {
        $base = "/afs/ir/group/homepage";
        $rest = $1;
        # WWW or cgi-bin?
        if ( (defined $rest) && ($rest =~ m#cgi-bin(/?.+)?#)) {
            $base .= "/cgi-bin";
            $rest = $1;
        }
        else {
            $base .= "/docs";
        }
    }

    $rest = '' unless defined $rest;
    $rest =~ s#/+$##;
    $rest =~ s#/+#/#g;
    return $base . $rest;
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

sub remctl {
    my $REMCTL = 'remctl';
    my ($server, @command) = @_;
    my $pid;
    
    eval {
        $pid = open (REMCTL, '-|');
    };
    if ($@) {
        return 1;
    }
    
    if (!defined $pid) {
        Carp::croak "Error forking remctl $!";
        return 1;
    } elsif ($pid == 0) {
        eval {
            exec ($REMCTL, $server, @command);
        };
        if ($@) {
            Carp::croak "Error running remctl $!";
            return 1;
        }
    } else {
        my @output = <REMCTL>;
        close REMCTL;
        return wantarray ? (($? >> 8), @output) : ($? >> 8);
    }
}

1;
