#!/usr/bin/perl
use strict;
use warnings;

# This is required because REDIRECT_ is added by Apache
# and REMOTE_USER is left blank
if (!(defined $ENV{REMOTE_USER}) && (defined $ENV{REDIRECT_REMOTE_USER})) {
   $ENV{REMOTE_USER} = $ENV{REDIRECT_REMOTE_USER};
}

# For now, we load the entire FB apparatus. Soon, we need to change this
# to load just the functions necessary to render and process a form
#use lib '/afs/ir/dept/its/cgi-bin/services/webforms/includes';
use lib 'includes';
use FB;

# These configuration bits are necessary for now, but again, will mostly
# be removed when we streamline this script
use AppConfig qw(:expand :argcount);

my $config = AppConfig->new(
    'language'           => { 
        ARGCOUNT => ARGCOUNT_ONE,
        DEFAULT => 'en_us',
    },
    'templates_path'     => {
        ARGCOUNT => ARGCOUNT_LIST,  
        DEFAULT => 'templates',
    },
    'max_forms_per_user' => { 
        ARGCOUNT => ARGCOUNT_ONE, 
        DEFAULT => 20,
    },
    'users_max_forms' => { 
        ARGCOUNT => ARGCOUNT_ONE, 
        DEFAULT => 20,
    },
    'users_can_create_new' => { 
        ARGCOUNT => ARGCOUNT_ONE, 
        DEFAULT => 1,
    },
    'users_can_create_automatically' => { 
        ARGCOUNT => ARGCOUNT_ONE, 
        DEFAULT => 1,
    },
	'domain_name' => {
		ARGCOUNT => ARGCOUNT_ONE,
		DEFAULT => 1,
	},
);

$config->file('includes/config.txt');

# Create a new instance of the formbuilder.
# Only a subset of the functions in FB.pm are needed to run forms so we need to
# still separate some of them. That way there won't be a need to compile form
# information every time one is called. We need to cache both templates and validation
# profiles
my $fb = new FB($config);

eval {
    $fb->run();
};

# Catch any un-caught exceptions. This will display a pretty message to the
# user so that they don't feel too bad. 
if ($@) {
    $fb->display_error(error_message => $@, fatal => 1);
}
