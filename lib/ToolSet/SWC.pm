package ToolSet::SWC;

our $VERSION = "0.10";

use base 'ToolSet';

ToolSet->set_strict(1);

ToolSet->set_warnings(1);

ToolSet->export(
    'Carp' => undef,
);

1; # true
__END__

=begin wikidoc

= NAME

ToolSet::SWC - Sample toolset with strict, warnings and Carp

= VERSION

This document describes ToolSet::SWC version 0.10

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

= BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests at
{bug-toolset@rt.cpan.org}, or through the web interface at
[http://rt.cpan.org].

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

= AUTHOR

David A Golden  {<dagolden@cpan.org>}

= LICENCE AND COPYRIGHT

Copyright (c) 2005, David A Golden {<dagolden@cpan.org>}. All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See the {LICENSE} file included with this
module.

= DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=end wikidoc
