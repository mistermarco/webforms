#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::TextArea;
use strict;

use FB::Form::Element;
our @ISA = qw(FB::Form::Element);

sub new {
    my ($class, %args) = @_; 
    my $self = {
        _label    => $args{label}    || "Untitled",
        _class    => $args{class}    || "textarea",
        _type     => $args{type}     || "textarea",
        _template => $args{template} || "textarea.tt",
        _is_required => 0,
    };
    bless $self, $class;
    return $self;
}

1;
