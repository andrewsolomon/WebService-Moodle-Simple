package WebService::Moodle::Simple::CLI::suspend;

use strict;
use warnings;
use Data::Dump 'pp';
use feature 'say';
use WebService::Moodle::Simple;


sub run {
  my $opts = shift;
  my $moodle = WebService::Moodle::Simple->new( %$opts );

  my $resp = $moodle->suspend_user(
    username  => $opts->{username},
    suspend   => $opts->{undo} ? 0 : 1,
  );

  say pp($resp);

}


1;
