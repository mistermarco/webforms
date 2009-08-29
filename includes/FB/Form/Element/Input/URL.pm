#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Input::URL;
use strict;

use FB::Form::Element::Input;
our @ISA = qw(FB::Form::Element::Input);

use Data::FormValidator::Constraints qw(:closures :regexp_common);

{
    our %defaults = (
        label    => "URL",
        class    => "url",
        type     => "input_url",
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
    $validation_profile->{'constraint_methods'}{$self->name} = FV_URI_HTTP(-scheme => qr/https?/);
    return $validation_profile;
}

1;
