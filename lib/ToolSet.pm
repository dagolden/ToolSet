package ToolSet;

use 5.006;
use strict;
use warnings;
use Carp;

our $VERSION = '0.14';

#--------------------------------------------------------------------------#
# package variables
#--------------------------------------------------------------------------#

my %use_pragmas;
my %no_pragmas;
my %exports_of;

#--------------------------------------------------------------------------#
# functions
#--------------------------------------------------------------------------#

sub export {
    my $class = shift;
    my %spec = @_;
    my $caller = caller;
    $exports_of{ $caller } = \%spec;
}

sub import {
    my ($class) = @_;
    my $caller = caller;
    if ( $use_pragmas{ $class } ) {
      for my $p ( keys %{ $use_pragmas{$class} } ) {
        my $module = $p;
        $module =~ s{::}{/}g;
        $module .= ".pm";
        require $module;
        $p->import( @{ $use_pragmas{ $class }{ $p } } );
      }
    }
    if ( $no_pragmas{ $class } ) {
      for my $p ( keys %{ $no_pragmas{$class} } ) {
        my $module = $p;
        $module =~ s{::}{/}g;
        $module .= ".pm";
        require $module;
        $p->unimport( @{ $no_pragmas{ $class }{ $p } } );
      }
    }
    while ( my ( $mod, $request ) = each %{ $exports_of{ $class } } ) {
        my $evaltext;
        if ( ! $request ) {
            $evaltext = "package $caller; use $mod";
        }
        elsif ( ref $request eq 'ARRAY' ) {
            my $args = join( q{ } => @$request );
            $evaltext =  "package $caller; use $mod qw( $args )";
        }
        elsif ( ref( \$request ) eq 'SCALAR' ) {
            $evaltext = "package $caller; use $mod qw( $request )";
        }
        else {
            croak "Invalid import specification for $mod";
        }
        eval $evaltext; ## no critic
        croak "$@" if $@;
    }

    # import from a @EXPORT array in the ToolSet subclass
    {
        no strict 'refs'; ## no critic
        for my $fcn ( @{"${class}::EXPORT"} ) {
            my $source = "${class}::${fcn}";
            die "Can't import missing subroutine $source"
                if ! defined *{$source}{CODE};
            *{"${caller}::${fcn}"} = \&{$source};
        }
    }
                
}

sub set_strict {
  my ($class, $value) = @_;
  return unless $value;
  my $caller = caller;
  $use_pragmas{ $caller }{ strict } = [];
}

sub set_warnings {
  my ($class, $value) = @_;
  return unless $value;
  my $caller = caller;
  $use_pragmas{ $caller }{ warnings } = [];
}

sub set_feature {
  my ($class, @args) = @_;
  return unless @args;
  my $caller = caller;
  $use_pragmas{ $caller }{ feature } = [ @args ];
}

sub use_pragma {
  my ($class, $pragma, @args) = @_;
  my $caller = caller;
  $use_pragmas{ $caller }{ $pragma } = [ @args ];
}

sub no_pragma {
  my ($class, $pragma, @args) = @_;
  my $caller = caller;
  $no_pragmas{ $caller }{ $pragma } = [ @args ];
}


1; # Magic true value required at end of module
__END__

=begin wikidoc

= NAME

ToolSet - Load your commonly-used modules in a single import

= VERSION

This documentation describes version %%VERSION%%.

= SYNOPSIS

Creating a ToolSet:

    # My/Tools.pm
    package My::Tools;

    use base 'ToolSet'; 
    
    ToolSet->use_pragma( 'strict' );
    ToolSet->use_pragma( 'warnings' );
    ToolSet->use_pragma( qw/feature say switch/ ); # perl 5.10

    # define exports from other modules
    ToolSet->export(
        'Carp'          => undef,       # get the defaults
        'Scalar::Util'  => 'refaddr',   # or a specific list
    );

    # define exports from this module
    our @EXPORT = qw( shout );
    sub shout { print uc shift };
    
    1; # modules must return true

Using a ToolSet:

    # my_script.pl
    
    use My::Tools;
    
    # strict is on
    # warnings are on
    # Carp and refaddr are imported
    
    carp "We can carp!";
    print refaddr [];
    shout "We can shout, too!";
  
= DESCRIPTION

ToolSet provides a mechanism for creating logical bundles of modules that can
be treated as a single, reusable toolset that is imported as one.  Unlike
CPAN bundles, which specify modules to be installed together, a toolset
specifies modules to be imported together into other code.  

ToolSet is designed to be a superclass -- subclasses will specify specific
modules to bundle.  ToolSet supports custom import lists for each included
module and even supports compile-time pragmas like {strict}, {warnings}
and {feature}. 

A ToolSet module does not physically bundle the component modules, but rather
specifies lists of modules to be used together and import specifications for
each.  By adding the component modules to a prerequisites list in a
{Makefile.PL} or {Build.PL} for a ToolSet subclass, an entire dependency chain
can be managed as a single unit across scripts or distributions that use the
subclass.

= INTERFACE 

== Setting up

    use base 'ToolSet';
    
ToolSet must be used as a base class.

== {@EXPORT}

    our @EXPORT = qw( shout };
    sub shout { print uc shift }

Functions defined in the ToolSet subclass can be automatically exported during
{use()} by listing them in an {@EXPORT} array.

== {export}

    ToolSet->export(
        'Carp' => undef,                    
        'Scalar::Util' => 'refaddr',
    );

Specifies packages and arguments to import via {use()}.  An argument of {undef}
or the empty string calls {use()} with default imports.  Arguments should be
provided either as a whitespace delimited string or in an anonymous array.  An
empty anonymous array will be treated like passing the empty list as an
argument to {use()}.  Here are examples of how how specifications will be
provided to {use()}:

    'Carp' => undef                 # use Carp; 
    'Carp' => q{}                   # use Carp;
    'Carp' => 'carp croak'          # use Carp qw( carp croak );
    'Carp' => [ '!carp', 'croak' ]  # use Carp qw( !carp croak );
    'Carp' => []                    # use Carp (); 
    
Elements in an array are passed to {use()} as a white-space separated list, so
elements may not themselves contain spaces or unexpected results will occur.

== {use_pragma}

  ToolSet->use_pragma( 'strict' );         # use strict;
  ToolSet->use_pragma( 'feature', ':5.10' ); # use feature ':5.10';

Specifies a compile-time pragma to enable and optional arguments to that
pragma.  This must only be used with pragmas that act via the magic {$^H} or
{%^H} variables.  It must not be used with modules that have other side-effects
during import() such as exporting functions.

== {no_pragma}

  ToolSet->no_pragma( 'indirect' ); # no indirect;

Like {use_pragma}, but disables a pragma instead.

If a pragma is specified in both a {use_pragma} and {no_pragma} statement, the
{use_pragma} will be executed first.  This allow turning on a pragma with 
default settings and then disabling some of them.

  ToolSet->use_pragma( 'strict' );
  ToolSet->no_pragma ( 'strict', 'refs' ); 

== {set_feature} (DEPRECATED)

*See {use_pragma} instead*

  ToolSet->set_feature( ":5.10" );
  ToolSet->set_feature( qw/say switch/ );

For Perl 5.10 or later, enables newer language features in modules the {use()} 
this one.

== {set_strict} (DEPRECATED)

*See {use_pragma} instead*

  ToolSet->set_strict(1);
  ToolSet->set_strict(0); # default

Determines whether strict will enabled for modules that {use()} this one.

== {set_warnings} (DEPRECATED)

*See {use_pragma} instead*

  ToolSet->set_warnings(1);
  ToolSet->set_warnings(0); # default

Determines whether warnings will enabled for modules that {use()} this one.

= DIAGNOSTICS

ToolSet will report an error for a module that cannot be found just like an
ordinary call to {use()} or {require()}.

Additional error messages include:

* {"Invalid import specification for MODULE"} -- an incorrect type was
provided for the list to be imported (e.g. a hash reference)

* {"Can't import missing subroutine NAME"} -- the named subroutine is listed in
{@EXPORT}, but is not defined in the ToolSet subclass

= CONFIGURATION AND ENVIRONMENT

ToolSet requires no configuration files or environment variables.

= DEPENDENCIES

ToolSet requires at least Perl 5.6.  ToolSet subclasses will, of course, be
dependent on any modules they load.

= SEE ALSO

Similar functionality is provided by the [Toolkit] module, though that 
module requires defining the bundle via text files found within directories
in {PERL5LIB} and uses source filtering to insert their contents as files
are compiled.

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
