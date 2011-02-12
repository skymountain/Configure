package Configure::Path;

use strict;
use warnings;

use Params::Validate;
use File::Spec;
use Configure::Ref qw/is_array/;

our $root_dir = File::Spec->rootdir;

sub normalize {
  my ($class, @paths) = @_;
  @paths = @paths != 1 ? @paths
                       : (is_array($paths[0]) ? @{$paths[0]} : ($paths[0]));
  map { $class->_normalize_one($_) } @paths;
}

sub _normalize_one {
  my ($class, $path) = validate_pos(@_, 1, 1);
  my @entries = map { /^\$(.*)$/ ? $ENV{$1} : $_ } split /\//, $path;
  File::Spec->catfile(@entries);
}

sub rel2abs {
  my ($class, $parent, $path) = validate_pos(@_, 1, 1, 1);
  $path =~ /^$root_dir/o ? $path : File::Spec->catfile($parent, $path);
}

sub normalize_and_abs {
  my ($class, $parent, @paths) = @_;
  map { $class->rel2abs($parent, $_) } $class->normalize(@paths);
}

1;
