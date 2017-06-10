package WebService::Moodle::Simple::CLI::set_password;

use strict;
use warnings;
use Data::Dump 'pp';
use feature 'say';
use WebService::Moodle::Simple;

# ABSTRACT: moodlews set_password method

sub run {
  my $opts = shift;
  my $moodle = WebService::Moodle::Simple->new( %$opts );

  my $resp = $moodle->set_password(
    password  => $opts->{password},
    username  => $opts->{username},
  );

  say pp($resp);

}


1;
