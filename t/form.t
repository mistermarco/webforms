#!/usr/bin/perl
use strict;
use Test::More qw(no_plan);

use lib '../includes';
use_ok('FB');
use_ok('FB::Form');

#
# Testing that Class Defaults are set
#
print "Testing Defaults...\n";
isnt(FB::Form->defaults('name'),        "", "Name is set"       );
isnt(FB::Form->defaults('description'), "", "Description is set");
isnt(FB::Form->defaults('theme'),       "", "Theme is set"      );
isnt(FB::Form->defaults('template'),    "", "Template is set"   );
isnt(FB::Form->defaults('css'),         "", "CSS is set"        );

#
# Testing the new() constructor with no values
#

print "Testing new() constructor\n";
my $form = FB::Form->new();
is($form->isa("FB::Form"), 1, "Object of type FB::Form created");

print "A new form:\n";
is($form->id,       undef,                      "has undefined ID");
is($form->path,     undef,                      "has undefined path");
is($form->name,     FB::Form->defaults('name'),     "has a default name");
is($form->template, FB::Form->defaults('template'), "has the default template");
is($form->css,      FB::Form->defaults('css'),      "has the default CSS file");
is($form->is_live,  0,                          "is not live");
is($form->description, 
    FB::Form->defaults('description'),              "has default description");
is($form->theme->isa("FB::Theme::Plain"), 1,    "gets the plain theme");
    


my @nodes = @{$form->nodes};
is($#nodes, -1, "has no nodes");

#
# Testing the new() constructor with no values
#

print "Testing new() constructor with values\n";
$form = FB::Form->new(
    id          => "123",
    name        => "form name",
    description => "form description",
    template    => "form template",
    css         => "form css",
    creator     => "creator",
);

is($form->isa("FB::Form"),  1,                  "FB::Form Object Created");
is($form->id,               "123",              "Form ID is set");
is($form->name,             "form name",        "Form name is set");
is($form->description,      "form description", "Form descripion is set");
is($form->template,         "form template",    "Form template is set");
is($form->css,              "form css",         "Form CSS is set");
is($form->creator,          "creator",          "Form creator is set");

# Make sure that people can't set a new form as live

$form = FB::Form->new(is_live => 1);
is($form->is_live, 0, "Form is not live by default");


#
# Testing accessors
#

# ID

$form->set_id("123");
is($form->id, "123", "Setting a new ID");

$form->set_id("123");
$form->set_id();
is($form->id, "123", "set_id() keeps original value");

$form->set_id("123");
$form->set_id("abc");
is($form->id, "123", "Non-integers keeps original value");


# Path

$form->set_path("form path");
is($form->path, "form path", "Setting a new path");


# Name

$form->set_name("Testing Form");
is($form->name, "Testing Form", "Setting a new name");

$form->set_name("Testing Form\n");
is($form->name, "Testing Form\n", "Setting a name with a return");

$form->set_name();
is($form->name, undef, "Setting undef name, returning undef");

$form->set_name("");
is($form->name, "", "Setting empty string name, returning empty name");

$form->set_name(0);
is($form->name, 0, "Setting name to 0, returning 0");

$form->set_name('The', 'Form');
is($form->name, 'The', "Ignoring extra parameters");

undef $form->{_name};
is($form->name, undef, "Returning undef if undef");


# Description

$form->set_description("Form Description");
is($form->description, "Form Description", "Setting a new description");


# Live status

$form = FB::Form->new();
$form->set_is_live(0);
is($form->is_live(), 0, "Making form not live");

$form->set_path("my_path"); # needed, see below
$form->set_is_live(1);
is($form->is_live(), 1, "Making form live");

$form->set_is_live(8);
is($form->is_live(), 0, "set_is_live only takes 1 or 0");

$form->set_path('');
$form->set_is_live(1);
is($form->is_live(), 0, "Form can't be live if there is no path");

$form->set_path("my_path");
$form->set_is_live(1);
$form->set_path('');
is($form->is_live(), 0, "Form can't be live if there is no path");

##############################################################################
# set_confirmation
#

$form = FB::Form->new();
$form->set_confirmation_method("text");
is($form->confirmation_method, "text", "setting confirmation to text works");

$form = FB::Form->new();
$form->set_confirmation_method("url");
is($form->confirmation_method, "url", "setting confirmation to url works");

my $message = "calling set_confirmation_method with undef fails";

$form = FB::Form->new();
eval {
    $form->set_confirmation_method();    
};
if ($@) { pass($message); } else { fail($message); }

$message = "calling set_confirmation_method with empty string";
$form = FB::Form->new();
eval {
    $form->set_confirmation_method("");
};
if ($@) { pass($message); } else { fail($message); }


$form = FB::Form->new();
$message = "calling set_confirmation_method with ' ' string";
eval {
    $form->set_confirmation_method(" ");
};
if ($@) { pass($message); } else { fail($message); }

$form = FB::Form->new();
eval {
    $form->set_confirmation_method("abc");
};
$message = "calling set_confirmation_method with no text/url string";
if ($@) { pass($message); } else { fail($message); }

##############################################################################
# Template
#

$form->set_template("form template");
is($form->template, "form template", "Setting a new template");

# CSS
$form->set_css("form css");
is($form->css, "form css", "Setting new CSS");

# Working with the database
$form = FB::Form->new();
my $form_id = $form->store();
isnt($form->id, undef, "Saving a new form sets its ID to the DB ID");
isnt($form_id, undef, "Saving a form, returns an ID")

# Theme

#use Data::Dumper; print Dumper $form;
#$form->render;

