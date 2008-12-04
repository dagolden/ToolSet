use strict;
use lib 't/lib';
use Test::More;

if ( $] >= 5.009 ) { 
  plan tests => 2;
}
else {
  plan skip_all => 'user-pragma tests require Perl 5.010';
}

my %pragmas;

my $in_effect = eval "use t::ToolSet::Pragmas; return bogopragma::in_effect()";

is($@, '', "no error in eval");
ok($in_effect, "bogus pragma set");
