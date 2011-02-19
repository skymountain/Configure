package Configure::Command::Base::Link;

use strict;
use warnings;

use base qw/Configure::Command::Base::Sequence/;
use Carp qw/croak/;
use Configure::Path;
use Configure::Command::Response;

sub new {
  bless {}, $_[0];
}

sub link {
  die "undef command";
}

sub execute_one {
  my ($self, $dir, $link) = @_;
  my $from = $link->{from}
      or return Configure::Command::Response->error("'from' file must be given in $dir");
  my $to = $link->{to}
      or return Configure::Command::Response->error("'to' file must be given in $dir");

  ($from, $to) = Configure::Path->normalize_and_abs($dir, $from, $to);

  my $res = $self->linkable($from, $to);
  return $res->is_success ? $self->link(
    dir  => $dir,
    from => $from,
    to   => $to,
    data => $link,
  ) : $res;
}

sub linkable {
  my ($self, $from, $to) = @_;

  if (!(-e $from)) {
    return Configure::Command::Response->error(
      "$from not exists",
    );
  }
  elsif (-e $to || -l $to) {
    return Configure::Command::Response->skip(
      "$to exists",
    );
  }

  return Configure::Command::Response->success;
}

1;
