package t::ToolBox::StrictWarn;
use base 'ToolBox';

ToolBox->set_strict(1);
ToolBox->set_warnings(1);

1; # return true
