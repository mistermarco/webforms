#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Form::Element::Output;
use strict;

use FB::Form::Element;
our @ISA = qw(FB::Form::Element);

{
  # This element is not submitted, so it makes no sense for it to be required
  sub can_be_submitted { return 0; }
  sub can_be_required  { return 0; }
  sub can_have_value   { return 1; }

  our %defaults = (
      label    => "Untitled Section",
      class    => "",
      value    => "Describe Section Here",
      type     => "output_section_header",
      template => "section_header.tt",
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
        _value    => $args{value}    || $class->defaults('value'),
        _template => $args{template} || $class->defaults('template'),
        _is_required => 0,
    };
    bless $self, $class;
    return $self;
}

1;
