package ToolSet::SWC;
use strict;

our $VERSION = '0.14';

use base 'ToolSet';

ToolSet->use_pragma( 'strict' );
ToolSet->use_pragma( 'warnings' );

ToolSet->export(
    'Carp' => undef,
);

1; # true
__END__

=begin wikidoc

= NAME

ToolSet::SWC - Sample toolset with strict, warnings and Carp

= VERSION

This documentation describes version %%VERSION%%.

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

= BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
[http://rt.cpan.org/Dist/Display.html?Queue=ToolSet]

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

= AUTHOR

David A. Golden (DAGOLDEN)

= COPYRIGHT AND LICENSE

Copyright (c) 2005-2008 by David A. Golden. All rights reserved.

Licensed under Apache License, Version 2.0 (the "License").
You may not use this file except in compliance with the License.
A copy of the License was distributed with this file or you may obtain a 
copy of the License from http://www.apache.org/licenses/LICENSE-2.0

Files produced as output though the use of this software, shall not be
considered Derivative Works, but shall be considered the original work of the
Licensor.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=end wikidoc
