package WebService::Moodle::Simple::CLI::add_user;

use strict;
use warnings;
use Data::Dump 'pp';
use feature 'say';
use WebService::Moodle::Simple;

# ABSTRACT: moodle add_user method

sub run {
  my $opts = shift;

  my $moodle = WebService::Moodle::Simple->new( %$opts );

  my $resp = $moodle->add_user(
    firstname => $opts->{firstname},
    lastname  => $opts->{lastname},
    email     => $opts->{email},
    password  => $opts->{password},
    username  => $opts->{username},
  );

  say pp($resp);

}


1;
