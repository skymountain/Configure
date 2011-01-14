#! /usr/bin/env perl

use strict;
use warnings;

use Path::Class;
use FindBin;
use lib file($FindBin::Bin)->parent->subdir('lib')->stringify;

use Configure::Command;



Configure::Command->new('install')->execute_from_config($ENV{DOTDIR});
