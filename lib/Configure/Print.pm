package Configure::Print;

use strict;
use warnings;

use List::Util qw/reduce/;
use Params::Validate;

my %phrase_hash = do {
  my @phrase_list =
    qw/
        skip
        error
        success
      /;
  my $length = length (reduce { length $a < length $b ? $b : $a } @phrase_list);
  map { $_ => sprintf "%-${length}s => ", $_ } @phrase_list;
};

sub p {
  my ($class, $phrase, $msg, $comm_name) = @_;
  print sprintf "$phrase_hash{$phrase}%s$msg\n", $comm_name ? "$comm_name: " : '';
}

sub skip    { shift->p('skip',    @_) }
sub error   { shift->p('error',   @_) }
sub success { shift->p('success', @_) }

sub print_response {
  my ($class, $res) = validate_pos(@_, 1, 1);
  return unless $res;

  my $reason = delete $res->{reason} or return;
  my $comm_name = delete $res->{command} or return;
  my $result = $res->{result};
  $class->$result($reason, $comm_name);
}

sub not_exists {
  my ($class, $file) = @_;
  $class->error("$file not exists");
}

1;
