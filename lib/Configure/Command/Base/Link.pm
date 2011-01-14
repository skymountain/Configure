package Configure::Command::Base::Link;

use strict;
use warnings;

use Configure::Path;

sub new {
  bless {}, $_[0];
}

sub link {
  die "undef command";
}

sub execute {
  my ($self, $dir, $links) = @_;
  foreach my $link (@$links) {
    my ($from, $to) = Configure::Path->system_path($dir, $link->{from}, $link->{to});
    $self->link(
      dir  => $dir,
      from => $from,
      to   => $to
    );
  }
}

1;
