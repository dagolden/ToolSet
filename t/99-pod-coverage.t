use Test::More;
plan skip_all => "Skipping author tests" if not $ENV{AUTHOR_TESTING};

eval "use Test::Pod::Coverage 1.08";
plan skip_all => "Test::Pod::Coverage 1.08 required for testing POD coverage"
    if $@;

eval "use Pod::Coverage 0.17";
plan skip_all => "Pod::Coverage 0.17 required for testing POD coverage"
    if $@;

all_pod_coverage_ok();
