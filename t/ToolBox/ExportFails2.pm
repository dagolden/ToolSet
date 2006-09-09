package t::ToolBox::ExportFails2;
use base 'ToolBox';

ToolBox->export(
    'Bogus::Module' => [],
);

1; # return true
