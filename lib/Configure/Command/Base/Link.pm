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

    if ($self->linkable($from, $to)) {
      $self->link(
        dir  => $dir,
        from => $from,
        to   => $to,
        data => $link,
      );
    }
  }
}

sub linkable {
  my ($self, $from, $to) = @_;

  if (!(-e $from)) {
    Configure::Print->not_exists($from);
  }
  elsif (-e $to || -l $to) {
    Configure::Print->skip("$to exists");
  }
  else {
    return 1;
  }

  return;
}

1;
