use strict;
use warnings;

package ToolSet::SWC;
# ABSTRACT: Sample toolset with strict, warnings and Carp

our $VERSION = '1.03';

use base 'ToolSet';

ToolSet->use_pragma('strict');
ToolSet->use_pragma('warnings');

ToolSet->export( 'Carp' => undef, );

1; # true
__END__

=head1 SYNOPSIS

    use ToolSet::SWC;
    
    # strict is on
    # warnings are on
    # Carp defaults are imported
    
    carp "We know how to carp";
    
    $name = "Igor";     # this will fail strict when compiling
  
=head1 DESCRIPTION

ToolSet:SWC is a simple example of a ToolSet that enables strict and warnings
and also imports all the basic L<Carp> functions. See L<ToolSet> for more
details.

=head1 SEE ALSO

=for :list
* L<ToolSet>

=cut
