#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Input;
use strict;

use FB::Form::Element;
our @ISA = qw(FB::Form::Element);

{
    our %defaults = (
        label    => "Untitled",
        class    => "input_text",
        type     => "input",
        template => "input_text.tt",
    );
    
    sub defaults {
        my $class = shift;
        my $property = shift;
        return $defaults{$property};
    }
}

sub new {
    my ($class, %args) = @_;
    my $self = {
        _label    => $args{label}    || $class->defaults('label'),
        _class    => $args{class}    || $class->defaults('class'),
        _type     => $args{type}     || $class->defaults('type'),
        _template => $args{template} || $class->defaults('template'),
        _is_required => 0,
        _is_required_in_collection => $args{is_required_in_collection} || 0,
    };
    bless $self, $class;
    return $self;
}

1;
