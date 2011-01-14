package Configure::Command::Base::Symlink;

use strict;
use warnings;

use strict;
use warnings;

use base qw/Configure::Command::Base::Link/;
use Configure::Print;

sub link {
  my ($self, %args) = @_;

  my $dir  = $args{dir};
  my $from = $args{from};
  my $to   = $args{to};

  if (symlink $from, $to) {
    Configure::Print->success("$from -> $to");
  }
  else {
    Configure::Print->error("symlink error $from -> $to, $! at $dir");
  }
}

1;
