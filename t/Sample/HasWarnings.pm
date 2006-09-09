package t::Sample::HasWarnings;

use t::ToolBox::StrictWarn;

my $var = "";
$var = $var + 1; # should warn

1; # return true
