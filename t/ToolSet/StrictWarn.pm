package t::ToolSet::StrictWarn;
use base 'ToolSet';

ToolSet->set_strict(1);
ToolSet->set_warnings(1);

1; # return true
