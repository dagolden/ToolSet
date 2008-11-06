package t::Sample::HasFeature;

use t::ToolSet::UseFeature;

my $foo;
my $bar;

given ($foo) {
  when (1)  { $bar = "hello world" }
  default   { $bar = "goodbye world" }
}

1; # return true
