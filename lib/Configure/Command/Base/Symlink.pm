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

  if (!(-e $from)) {
    Configure::Print->skip("$from not exists");
  }
  elsif (-e $to) {
    Configure::Print->skip("$to exists");
  }
  elsif (symlink $from, $to) {
    Configure::Print->success("symlink: $from -> $to");
  }
  else {
    Configure::Print->error("symlink error, $! at $dir");
  }
}

1;
