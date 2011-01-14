package Configure::Command::Install;

use strict;
use warnings;

use base qw/Configure::Command/;

use Configure::Command::Base::Subdir;
use Configure::Command::Base::Symlink;
use Configure::Command::Base::Prototype;

sub new {
  bless {
    subdir  => Configure::Command::Base::Subdir->new('install'),
    symlink => Configure::Command::Base::Symlink->new,
    prototype => Configure::Command::Base::Prototype->new,
  }, $_[0];
}

sub command_instance {
  my ($self, $comm_name) = @_;
  return $self->{$comm_name};
}

sub is_available {
  my $self = shift;
  $self->command_instance(@_);
}

1;
