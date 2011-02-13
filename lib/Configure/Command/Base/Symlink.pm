package Configure::Command::Base::Symlink;

use strict;
use warnings;

use strict;
use warnings;

use base qw/Configure::Command::Base::Link/;
use Configure::Print;
use Configure::Command::Response;

sub link {
  my ($self, %args) = @_;

  my $dir  = $args{dir};
  my $from = $args{from};
  my $to   = $args{to};

  if (symlink $from, $to) {
    Configure::Command::Response->success("$from -> $to");
  }
  else {
    Configure::Command::Response->error("symlink error $from -> $to, $! at $dir");
  }
}

1;
