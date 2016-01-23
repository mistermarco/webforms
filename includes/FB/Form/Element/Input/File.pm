#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008-2011 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Input::File;
use strict;

use FB::Form::Element::Input;
our @ISA = qw(FB::Form::Element::Input);

use Data::FormValidator::Constraints qw(:closures :regexp_common);

{
    sub instructions { return '<strong>Please Note:</strong><br />Files are <em>sent to you by email</em>, and are <strong>not stored in the database</strong>.<br />Make sure that you have specified email or both email and database as the submission method under the Publish tab or you won&rsquo;t receive file attachments.<br />Submissions have a size limit of <em>50MB shared among all file upload fields</em>.' ; }

    our %defaults = (
        label    => "File",
        class    => "file",
        type     => "input_file",
        template => "input_file.tt",
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
#    $validation_profile->{'constraint_methods'}{$self->name} = FV_URI_HTTP(-scheme => qr/https?/);
    return $validation_profile;
}

1;
