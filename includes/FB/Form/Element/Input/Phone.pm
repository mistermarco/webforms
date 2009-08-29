#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Input::Phone;
use strict;

use FB::Form::Element::Input;
our @ISA = qw(FB::Form::Element::Input);

use Data::FormValidator::Constraints qw(:closures :regexp_common);

{
    our %defaults = (
        label    => "Phone",
        class    => "phone",
        type     => "input_phone",
        template => "input_text.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

sub validation_profile {
    my $self = shift;
    my $validation_profile = $self->SUPER::validation_profile();
    $validation_profile->{'constraint_methods'}{$self->name} = phone();
    return $validation_profile;
}

1;
