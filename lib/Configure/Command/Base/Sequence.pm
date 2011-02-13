package Configure::Command::Base::Sequence;

use strict;
use warnings;

use base qw/Configure::Command::Base/;
use Params::Validate;
use Configure::Print;
use Configure::Command::Response;

sub new { bless {}, $_[0] }
sub execute {
  my ($self, $dir, $seq) = validate_pos(@_, 1, 1, 1);

  foreach my $x (@$seq) {
    my $res = $self->execute_one($dir, $x);
    Configure::Print->print_response($res);
  }
}

1;
