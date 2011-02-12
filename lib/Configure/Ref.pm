package Configure::Ref;

use strict;
use warnings;

use Exporter::Lite;
our @EXPORT_OK = qw/is_array/;

sub is_array  { ref $_[0] eq 'ARRAY' }
sub is_scalar { ref $_[0] eq '' }
sub is_hash   { ref $_[0] eq 'HASH' }
sub is_sub    { ref $_[0] eq 'CODE' }

1;
