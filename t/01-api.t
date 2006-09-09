#!perl -T
use Test::More tests => 5;
use lib '.';

BEGIN { use_ok( "t::ToolBox::Null" ); }

# ToolBox API
can_ok( "ToolBox", "set_strict" );
can_ok( "ToolBox", "set_warnings" );
can_ok( "ToolBox", "export" );

# Available in subclass
can_ok( "t::ToolBox::Null", "import" );

