#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Input::Email;
use strict;

use FB::Form::Element::Input;
our @ISA = qw(FB::Form::Element::Input);

use Data::FormValidator::Constraints qw(:closures :regexp_common);

{
    our %defaults = (
        label    => "Email",
        class    => "email",
        type     => "input_email",
        template => "input_email.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }

  # The Email input, can be autofilled
  sub can_be_autofilled { return 1; }

}

sub validation_profile {
    my $self = shift;
    my $validation_profile = $self->SUPER::validation_profile();
    $validation_profile->{'constraint_methods'}{$self->name} = email();
    return $validation_profile;
}

1;
