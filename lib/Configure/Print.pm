package Configure::Print;

use strict;
use warnings;

use feature qw/say/;
use List::Util qw/reduce/;

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
  my ($class, $phrase, $msg) = @_;
  say "$phrase_hash{$phrase}$msg";
}

sub skip {
  my ($class, $msg) = @_;
  $class->p('skip', $msg);
}

sub error {
  my ($class, $msg) = @_;
  $class->p('error', $msg);
}

sub success {
  my ($class, $msg) = @_;
  $class->p('success', $msg);
}

1;
