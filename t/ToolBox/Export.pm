package t::ToolBox::Export;
use base 'ToolBox';

ToolBox->export(
    'Carp' => undef,
    'Getopt::Std' => '',
    'Text::Wrap' => [],
    'File::Basename' => 'basename',
    'File::Spec::Functions' => 'devnull catdir',
    'Cwd' => [qw( cwd fastcwd )],
    'File::Path' => '!mkpath',
);

1; # return true
