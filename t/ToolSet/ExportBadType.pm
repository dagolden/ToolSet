package t::ToolSet::ExportBadType;
use base 'ToolSet';

ToolSet->export( 'Carp' => {}, );

1; # return true
