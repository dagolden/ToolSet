#!perl -T
use lib '.';
use Test::More tests => 20;
use t::Util; # gives us cant_ok()

BEGIN { use_ok( "t::ToolSet::Export" ) }

# 'Carp' => undef
can_ok( "main", "carp" );

# 'Getopt::Std' => ''
can_ok( "main", $_ ) for qw( getopt getopts );

# 'Text::Wrap' => []
cant_ok( "main", $_ ) for qw( wrap fill );

# 'File::Basename' => 'basename'
can_ok( "main", "basename" );
cant_ok( "main", "dirname" );

# 'File::Spec::Functions' => [ 'devnull', 'catdir' ],
# shouldn't import defaults like rootdir
can_ok( "main", "devnull" );
can_ok( "main", "catdir" );
cant_ok( "main", "rootdir" );

# 'Cwd' => [qw( cwd fastcwd )],
can_ok( "main", $_ ) for qw( cwd fastcwd );
cant_ok( "main", $_ ) for qw( getcwd fastgetcwd );

# 'File::Path' => [ '!mkpath' ]
can_ok( "main", "rmtree" );
cant_ok( "main", "mkpath" );

# Test error handling if module not found
eval " use t::ToolSet::ExportFails ";
like( "$@", qr{Can't locate Bogus/Module.pm in \@INC},
    "Missing module throws error (no args)"
);
# Ditto but with an argument to module
eval " use t::ToolSet::ExportFails2 ";
like( "$@", qr{Can't locate Bogus/Module.pm in \@INC},
    "Missing module throws error (arg style)"
);

# Test error handling for bad value type
eval " use t::ToolSet::ExportBadType ";
like( "$@", qr{Invalid import specification for Carp},
    "Invalid import spec throws error"
);
