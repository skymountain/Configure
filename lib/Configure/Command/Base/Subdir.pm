package Configure::Command::Base::Subdir;

use strict;
use warnings;

use Configure::Path;
use Configure::Command;

sub new {
  my ($class, $comm_name) = @_;
  bless {
    command => $comm_name,
  }, $class;
}

sub execute {
  my ($self, $dir, $subdirs) = @_;
  my @abs_subdirs = Configure::Path->system_path($dir, @$subdirs);

  Configure::Command->new($self->{command})->execute_from_config($_)
      foreach (@abs_subdirs);
}

1;
