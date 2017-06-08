package WebService::Moodle::Simple::CLI::get_user;

use strict;
use warnings;
use Data::Dump 'pp';
use feature 'say';
use WebService::Moodle::Simple;


sub run {
  my $opts = shift;
  my $moodle = WebService::Moodle::Simple->new( %$opts );

  my $resp = $moodle->get_user(
    username  => $opts->{username},
  );

  say pp($resp);

}


1;
