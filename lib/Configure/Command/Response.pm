package Configure::Command::Response;

use strict;
use warnings;

use Params::Validate;
use Carp;
use Configure::Ref qw/is_sub/;

our %response_hash = map { $_ => 1 } qw/
    success
    error
    skip
/;

our $AUTOLOAD;
sub AUTOLOAD {
  my $response = $AUTOLOAD;
  $response =~ s/.*:://;

  no strict 'refs';
  if ($response_hash{$response}) {
    *$AUTOLOAD = sub {
      my ($pkg) = caller;
      $pkg =~ s/.*:://;
      shift->new( $response, "\l$pkg", @_ );
    };
  }
  elsif ($response =~ /^is_(.*)$/ && $response_hash{$1}) {
    my $res = $1;
    *$AUTOLOAD = sub { $_[0]->{result} eq $res };
  }
  else {
    croak sprintf 'Can\'t locate object method "%s" via package %s',
      $response, ref $_[0] || $_[0]
  }

  goto &$AUTOLOAD;
}

sub new {
  my ($class, $result, $comm_name, $reason) = validate_pos(@_, 1, 1, 1, 0);
  bless {
    result  => $result,
    command => $comm_name,
    reason  => $reason,
  }, $class;
}

1;
