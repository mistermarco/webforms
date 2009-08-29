#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::Localization;

use Locale::Maketext 1.01;
use base ('Locale::Maketext');

# I decree that this project's first language is English.

%Lexicon = (
  '_AUTO' => 1,
  # That means that lookup failures can't happen -- if we get as far
  #  as looking for something in this lexicon, and we don't find it,
  #  then automagically set $Lexicon{$key} = $key, before possibly
  #  compiling it.
  
  # The exception is keys that start with "_" -- they aren't auto-makeable.
);
# End of lexicon.

1;  # End of module.
