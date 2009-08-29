package FB::Theme;

use strict;
use warnings;


{
    my $default_template = "simple_form.tt";
    sub default_template { return $default_template; };
    
    my $default_css
        = "http://www.stanford.edu/dept/its/projects/documentation/"
        . "form_builder/simple.css";
    sub default_css { return $default_css; }

    my $default_path = "../includes/templates/";
    sub default_path { return $default_path; }
}

##############################################################################
# Usage       : $theme = FB::Theme->new()
# Purpose     : Creates a new Theme object
# Returns     : A FB::Theme object
# Parameters  : Can take no parameters, or some initial values
# Throws      : no exceptions
# Comments    : none
# See Also    : n/a

# TODO: Error Checking
# TODO: Testing Code

sub new {
    my ($class, %args) = @_;
    my $self = {
        _template       => $args{template}       || $class->default_template,
        _css            => $args{css}            || $class->default_css,
        _templates_path => $args{templates_path} || $class->default_path,
    };
    bless $self, $class;
    return $self;
}

##############################################################################
# Accessors
#

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

sub templates_path {
    return $_[0]->{_templates_path};
}

1; 
