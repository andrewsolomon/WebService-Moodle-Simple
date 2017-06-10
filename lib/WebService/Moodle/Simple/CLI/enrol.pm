package WebService::Moodle::Simple::CLI::enrol;

use strict;
use warnings;
use Data::Dump 'pp';
use feature 'say';
use WebService::Moodle::Simple;


sub run {
  my $opts = shift;
  my $moodle = WebService::Moodle::Simple->new( %$opts );

  my $resp = $moodle->enrol_student(
    username  => $opts->{username},
    course    => $opts->{course},
  );

  say pp($resp);

}


1;
