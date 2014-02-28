use strict;
use warnings;
use Test::More;
use WebService::Moodle::Simple;
use Data::Dumper;

unless ($ENV{TEST_WSMS_ADMIN_PWD} && $ENV{TEST_WSMS_DOMAIN} && $ENV{TEST_WSMS_TARGET}) {
  plan skip_all => 'Not running live tests. Set $ENV{TEST_WSMS_ADMIN_PWD}, $ENV{TEST_WSMS_DOMAIN} and $ENV{TEST_WSMS_TARGET} to enable';
}

my $moodle = WebService::Moodle::Simple->new( 
  domain   =>  $ENV{TEST_WSMS_DOMAIN},
  target   =>  $ENV{TEST_WSMS_TARGET},
);

is(ref($moodle), 'WebService::Moodle::Simple');
my $login = $moodle->login(username => 'admin', password => $ENV{TEST_WSMS_ADMIN_PWD});

note Dumper $login;


done_testing();


