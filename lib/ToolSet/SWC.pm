use strict;
use warnings;

package ToolSet::SWC;
# ABSTRACT: Sample toolset with strict, warnings and Carp
# VERSION

use base 'ToolSet';

ToolSet->use_pragma( 'strict' );
ToolSet->use_pragma( 'warnings' );

ToolSet->export(
    'Carp' => undef,
);

1; # true
__END__

=begin wikidoc

= SYNOPSIS

    use ToolSet::SWC;
    
    # strict is on
    # warnings are on
    # Carp defaults are imported
    
    carp "We know how to carp";
    
    $name = "Igor";     # this will fail strict when compiling
  
= DESCRIPTION

ToolSet:SWC is a simple example of a ToolSet that enables strict and warnings
and also imports all the basic [Carp] functions. See [ToolSet] for more
details.

= SEE ALSO

* [ToolSet]

=end wikidoc
