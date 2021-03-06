package WebService::Moodle::Simple::CLI::check_password;

use strict;
use warnings;
use Data::Dump 'pp';
use feature 'say';
use WebService::Moodle::Simple;

# ABSTRACT: moodle check_password method

sub run {
  my $opts = shift;
  my $moodle = WebService::Moodle::Simple->new( %$opts );

  my $resp = $moodle->check_password(
    password  => $opts->{password},
    username  => $opts->{username},
  );

  say pp($resp);

}


1;
