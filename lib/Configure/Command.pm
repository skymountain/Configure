package Configure::Command;

use strict;
use warnings;

use UNIVERSAL::require;
use File::Spec;
use YAML::XS qw/LoadFile/;

our $config_file = 'conf.yml';

# class method
our %LOADED;
sub load {
  my ($class, $class_name) = @_;
  my $module = join '::', $class, $class_name;

  unless ($LOADED{$module}) {
    $module->require or return;
    $LOADED{$module} = 1;
  }

  return $module;
}

sub class_of_command {
  return "\u$_[1]";
}

sub config_file {
  my ($class, $dir) = @_;
  return File::Spec->catfile($dir, $config_file);
}

# instance method
sub new {
  my ($class, $comm_name) = @_;
  bless {
    command => $comm_name,
  }, $class;
}

sub execute {
  my ($self, $dir, $comms) = @_;
  my $path = $self->config_file($dir);

  while (my ($k, $v) = each %$comms) {
    if (my $comm = $self->command_instance($k)) {
      $comm->execute($dir, $v);
    }
    elsif (!$self->is_available($k)) {
      Configure::Print->error("$k is unknown command at $dir");
    }
  }
}

sub execute_from_config {
  my ($self, $dir) = @_;
  my $path = $self->config_file($dir);
  
  my $comms = eval { LoadFile($path); };
  if ($@) {
    die "$@ at $path";
  }

  $self->execute($dir, $comms);
}

## overridable method
sub command_instance {
  my ($self, $comm_name) = @_;

  if ($comm_name eq $self->{command}) {
    my $class_name = $self->class_of_command($comm_name);
    if (my $module = __PACKAGE__->load($class_name)) {
      return $module->new;
    }
  }
}

sub is_available {
  my ($self, $comm_name) = @_;
  return __PACKAGE__->load($self->class_of_command($comm_name));
}

1;
