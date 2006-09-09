package t::ToolBox::ExportBadType;
use base 'ToolBox';

ToolBox->export(
    'Carp' => {},
);

1; # return true
