package t::Sample::NotStrictError;

use t::ToolBox::StrictWarn;

$var = 42;
$var++;

1; # return true
