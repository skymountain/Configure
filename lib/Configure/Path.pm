package Configure::Path;

use strict;
use warnings;

use File::Spec;

our $rootdir_pattern = do {
  my $rootdir = File::Spec->rootdir;
  qr/^${rootdir}/o;
};

sub system_path {
  my ($class, $parent, @paths) = @_;
  my @ret;

  foreach my $path (@paths) {
    my @entries;

    foreach my $entry (split /\//, $path) {

      if ($entry =~ /^\$(.*)$/) {
        $entry = $ENV{$1};
      }
      push @entries, $entry;
    }

    my $path = File::Spec->catfile(@entries);
    if ($path !~ /$rootdir_pattern/) {
      $path = File::Spec->catfile($parent, $path);
    }
    push @ret, $path;
  }
  
  return @ret;
}

1;
