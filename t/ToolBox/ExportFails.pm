package t::ToolBox::ExportFails;
use base 'ToolBox';

ToolBox->export(
    'Bogus::Module' => undef,
);

1; # return true
