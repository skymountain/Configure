#! /usr/bin/env perl

use strict;
use warnings;

use Path::Class;
use FindBin;
use lib file($FindBin::Bin)->parent->subdir('lib')->stringify;

use Configure::Command;
use Configure::Print;

my $comm_name = $ARGV[0];
my $init_dir  = $ARGV[1];

unless ($comm_name && $init_dir) {
  Configure::Print->error("you must specify command name and initial directory");
  exit;
}

Configure::Command->new($comm_name)->execute_from_config($init_dir);
