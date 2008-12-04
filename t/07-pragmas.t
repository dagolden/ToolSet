use strict;
use lib 't/lib';
use Test::More;

plan tests => 2;

local $^W = 0; # Module::Build enables global warnings -- we need them off

my %pragmas;

my $in_effect = eval "use t::ToolSet::Pragmas; return bogopragma::in_effect()";

is($@, '', "no error");
ok($in_effect, "bogus pragma set");
