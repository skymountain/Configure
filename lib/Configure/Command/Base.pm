package Configure::Command::Base;

use strict;
use warnings;

sub new { die join '::', __PACKAGE__, 'new' }
sub execute { die join '::', __PACKAGE__, 'execute' }

1;
