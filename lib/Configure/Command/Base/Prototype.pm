package Configure::Command::Base::Prototype;

use strict;
use warnings;

use IO::File;

use base qw/Configure::Command::Base::Link/;

sub link {
  my ($self, %args) = @_;

  my $dir  = $args{dir};
  my $from = $args{from};
  my $to   = $args{to};
  my $reps = $args{data}->{replace};

  my $from_io = IO::File->new($from, 'r') or do {
    Configure::Print->error("$from can't open for read");
    return;
  };

  print "\n", "ask you what string in $from is replaced with ...\n";
  my %replaced;
  foreach my $rep (@$reps) {
    print "$rep: ";
    chomp($replaced{$rep} = (<STDIN>));
  }

  my @lines;
  foreach my $line ($from_io->getlines) {
    while (my ($from_str, $to_str) = each %replaced) {
      $line =~ s/$from_str/$to_str/g;
    }
    push @lines, $line;
  }

  my $to_io = IO::File->new($to, 'w') or do {
    Configure::Print->error("$to can't open for write");
    return;
  };
  $to_io->print(@lines);

  $from_io->close;
  $to_io->close;

  Configure::Print->success("$from -> $to");
}

1;
