package ToolSet;

use 5.006;
use strict;
use warnings;
use Carp;

our $VERSION = '0.14';

#--------------------------------------------------------------------------#
# package variables
#--------------------------------------------------------------------------#

my %pragmas;
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
    if ( $pragmas{ $class } ) {
      for my $p ( keys %{ $pragmas{$class} } ) {
        my $module = $p;
        $module =~ s{::}{/}g;
        $module .= ".pm";
        require $module;
        $p->import( @{ $pragmas{ $class }{ $p } } );
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
  $pragmas{ $caller }{ strict } = [];
}

sub set_warnings {
  my ($class, $value) = @_;
  return unless $value;
  my $caller = caller;
  $pragmas{ $caller }{ warnings } = [];
}

sub set_feature {
  my ($class, @args) = @_;
  return unless @args;
  my $caller = caller;
  $pragmas{ $caller }{ feature } = [ @args ];
}

sub set_pragma {
  my ($class, $pragma, @args) = @_;
  my $caller = caller;
  $pragmas{ $caller }{ $pragma } = [ @args ];
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
    
    ToolSet->set_strict(1);
    ToolSet->set_warnings(1);
    ToolSet->set_feature( qw/say switch/ ); # perl 5.10

    # define exports from other modules
    ToolSet->export(
        'Carp'          => undef,       # get the defaults
        'Scalar::Util'  => 'refaddr',   # or a specific list
    );

    # define exports from this module
    our @EXPORT = qw( shout );
    sub shout { print uc shift };
    
    1; # modules must be true

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
module and even supports the {strict} and {warnings} pragmas, optionally
enabling those pragmas when the ToolSet subclass is used.

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

Functions defined in the ToolSet subclass can be exported by default during
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

== {set_feature}

  ToolSet->set_feature( ":5.10" );
  ToolSet->set_feature( qw/say switch/ );

For Perl 5.10 or later, enables newer language features in modules the {use()} 
this one.

== {set_strict}

  ToolSet->set_strict(1);
  ToolSet->set_strict(0); # default

Determines whether strict will enabled for modules that {use()} this one.

== {set_warnings}

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

= INCOMPATIBILITIES

The only pragmas that are explicitly supported are {strict} and {warnings}, as
these have a lexical scope and will not function properly if called from within
the {eval} statement used for importing other modules.  Other pragmas may or
may not work depending on if they have a compile-time or run-time effect.

= SEE ALSO

Similar functionality is provided by the [Toolkit] module, though that 
module requires defining the bundle via text files found within directories
in {PERL5LIB} and uses source filtering to insert their contents as files
are compiled.

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
