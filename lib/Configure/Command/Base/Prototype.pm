package Configure::Command::Base::Prototype;

use strict;
use warnings;

use base qw/Configure::Command::Base::Link/;
use IO::File;
use List::Util qw/reduce/;
use Params::Validate;
use Configure::Command::Response;

our ($a, $b);
my $default_perm = sprintf '%o', 0777 - umask;
my $default_binary_perm = oct $default_perm;

sub link {
  my ($self, %args) = @_;

  my $dir  = $args{dir};
  my $from = $args{from};
  my $to   = $args{to};
  my $reps = $args{data}->{replace};
  my $perm = $self->_permission( $args{data}{permission} || $default_perm )
      or return Configure::Command::Response->error("$args{data}{permission} is invalid permission");

  my $from_io = IO::File->new($from, 'r') or
    return Configure::Command::Response->error(
      "$from can't open for read",
    );

  print "\n", "ask you what string in $from is replaced with ...\n";

  my %replaced;
  {
      my $continue = 1;
      my $prev = $SIG{INT} || undef;
      $SIG{INT} = sub { $continue = 0; die };
      eval {
          foreach my $rep (@$reps) {
              last unless $continue;
              print "$rep: \n";
              chomp($replaced{$rep} = (<STDIN>));
          }
      };
      $prev ? $SIG{INT} = $prev : delete $SIG{INT};
      die $@ if $@ && $continue;
      return Configure::Command::Response->skip("interrupted in $from") unless $continue;
  }

  my @lines;
  foreach my $line ($from_io->getlines) {
    while (my ($from_str, $to_str) = each %replaced) {
      $line =~ s/$from_str/$to_str/g;
    }
    push @lines, $line;
  }

  my $to_io = IO::File->new($to, 'w') or
    return Configure::Command::Response->error(
      "$to can't open for write",
    );

  $to_io->print(@lines);

  $from_io->close;
  $to_io->close;

  chmod $perm, $to;

  Configure::Command::Response->success("$from -> $to");
}

my %perm_hash = (
    r => 0400,
    w => 0200,
    x => 0100,
);
sub _permission {
    my ($self, $perm) = validate_pos(@_, 1, 1);

    if ($perm =~ qr'^[0-7]{1,3}$') {
        return oct $perm;
    }
    elsif ($perm =~ qr'^\+([rwx]+)') {
        my $options = $1;
        return $default_binary_perm | reduce { $a | $perm_hash{$b} } 0, split qr'', $options;
    }
    return;
}

1;
