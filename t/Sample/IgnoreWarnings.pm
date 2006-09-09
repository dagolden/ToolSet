package t::Sample::IgnoreWarnings;

use t::ToolBox::Null;

my $var = "";
$var = $var + 1; # shouldn't warn

1; # return true
