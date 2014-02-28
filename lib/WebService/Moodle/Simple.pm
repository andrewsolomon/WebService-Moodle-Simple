package WebService::Moodle::Simple;

use 5.008_005;
our $VERSION = '0.02';

use Moo;
use namespace::clean;
use URI;
use HTTP::Request;
use LWP::UserAgent;
use Sys::SigAction qw( timeout_call );
use JSON;
use Ouch;
use List::Util qw/first/;
use feature 'say';

my $REST_FORMAT = 'json';

# the base domain like moodle.example.com
has domain => (
  is => 'ro',
);

has port => (
  is      => 'rw',
  default => 80,
);

has timeout => (
  is      => 'rw',
  default => 12,
);

has target => (
  is      => 'rw',
);


has scheme => (
  is      => 'rw',
  default => 'http',
);

sub dns_uri {
  my $self = shift;
  return URI->new($self->scheme.'://'.$self->domain.':'.$self->port);
}

sub rest_call {
  my ($self, $dns_uri) = @_;

  my $res;

  my $timeout = $self->timeout + 1;

  if (timeout_call( $timeout,
    sub {
      my $req = HTTP::Request->new (GET => $dns_uri);
      $req->content_type('application/json');

      my $lwp = LWP::UserAgent->new;
      $lwp->timeout($timeout);
      $res = $lwp->request( $req );
    })) {
    ouch 408, 'Timeout: no response from '.$self->domain;
  }

  unless ($res->is_success) {
    ouch $res->code, $res->message;
  }

  return $res;
}

sub token {
  my $self = shift;
  my %args = (
    username => undef,
    password => undef,
    @_
  );

  my $dns_uri = $self->dns_uri;
  $dns_uri->path('login/token.php');
  $dns_uri->query_form( {
    username => $args{username},
    password => $args{password},
    service  => $self->target,
  });

  my $res = $self->rest_call($dns_uri);

  return from_json($res->content);
}

sub login  {
  my $self = shift;
  my %args = (
    username => undef,
    password => undef,
    @_
  );

say '=====================================';
use Data::Dumper;
say Dumper \%args;
say Dumper $self;
say '=====================================';

  my $username = $args{username};
  my $password = $args{password};
  my $target = $self->target;

  my $token = $self->token(
    username  => $username,
    password  => $password,
  );



  if (defined($token->{token})) {
    return {
      msg => "'$username' has access to the '$target' web service",
      ok  => 1,
      token => $token->{token},
    };
  }
  elsif ($token->{error} =~ m/No permission/) {
    return {
      msg => "'$username' has the correct password but no access to the '$target' web service",
      ok => 1,
    };
  }
  elsif ($token->{error} =~ m/username was not found/) {
    return {
      msg => "'$username' does not exist, or did not enter the correct password",
      ok  => 0,
    };
  }
  else {
    ouch 'MSE:0001', "Service '$target': ".$token->{error}, $token;
  }

}

sub set_password {
  my $self = shift;
  my %args = (
    username  => undef,
    password   => undef,
    token     => undef,
    @_
  );


  my $username = lc($args{username});


  my $params = {
    'wstoken'                      => $args{token},
    'wsfunction'                   => "core_user_update_users",
    'moodlewsrestformat'           => $REST_FORMAT,
    'users[0][id]'                 => $self->get_user(token => $args{token},, username => $username )->{id},
    'users[0][password]'           => $args{password},
  };


  my $dns_uri = $self->dns_uri;
  $dns_uri->path('webservice/rest/server.php');
  $dns_uri->query_form( $params );

  my $res = $self->rest_call($dns_uri);

  return $res->is_success;
}

sub add_user {
  my $self = shift;
  my %args = (
    firstname => undef,
    lastname  => undef,
    email     => undef,
    username  => undef,
    token     => undef,
    password  => undef,
    @_
  );


  my $username = lc($args{username});


  say "Attempting to create user account '$username'";

  my $params = {
    'wstoken'                      => $args{token},
    'wsfunction'                   => "core_user_create_users",
    'moodlewsrestformat'           => $REST_FORMAT,
    'users[0][username]'           => $username,
    'users[0][email]'              => $args{email},
    'users[0][firstname]'          => $args{firstname},
    'users[0][lastname]'           => $args{lastname},
    'users[0][password]'           => $args{password},
  };


  my $dns_uri = $self->dns_uri;
  $dns_uri->path('webservice/rest/server.php');
  $dns_uri->query_form( $params );

  my $res = $self->rest_call($dns_uri);

  return from_json($res->content);
}

sub get_users {
  my $self = shift;
  my %args = (
    token     => undef,
    @_
  );


  my $params = {
    'wstoken'                      => $args{token},
    'wsfunction'                   => "core_user_get_all_users",
    'moodlewsrestformat'           => $REST_FORMAT,
  };


  my $dns_uri = $self->dns_uri;
  $dns_uri->path('webservice/rest/server.php');
  $dns_uri->query_form( $params );

  my $res = $self->rest_call($dns_uri);

  return from_json($res->content);
}

sub enrol_student {
  my $self = shift;
  my %args = (
    username   => undef,
    course => undef,
    token      => undef,
    @_
  );

  my $user_id = $self->get_user(
    token => $args{token},
    username => $args{username}
  )->{id};
  


  my $sturole = $self->get_student_role( token => $args{token} );
  my $params = {
    'wstoken'                      => $args{token},
    'wsfunction'                   => "enrol_manual_enrol_users",
    'moodlewsrestformat'           => $REST_FORMAT,
    'enrolments[0][roleid]'        => $sturole->{id},
    'enrolments[0][userid]'        => $user_id,
    'enrolments[0][courseid]'      => $self->get_course_id (  token => $args{token}, short_cname => $args{course} ),
  };


  my $dns_uri = $self->dns_uri;
  $dns_uri->path('webservice/rest/server.php');
  $dns_uri->query_form( $params );

  my $res = $self->rest_call($dns_uri);
  unless ($res->is_success) {
    ouch $res->code, $res->message;
  }
  return 1;
}

sub get_course_id {
  my $self = shift;
  my %args = (
    short_cname => undef,
    token       => undef,
    @_
  );

  my $dns_uri = $self->dns_uri;
  $dns_uri->path('webservice/rest/server.php');
  $dns_uri->query_form( {
    wstoken   => $args{token},
    wsfunction => 'core_course_get_courses',
    moodlewsrestformat => $REST_FORMAT,
  } );

  my $res = $self->rest_call($dns_uri);
  my $ra_courses = from_json($res->content);
    foreach my $rh_course (@$ra_courses) {
say '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
use Data::Dumper;
say Dumper $rh_course;
      if ($rh_course->{shortname} eq $args{short_cname}) {
        return $rh_course->{id};
      }
  }


  ouch 'MSE-0002', 'failed to find course of name '.$args{short_cname};
}

sub get_student_role {
  my $self = shift;
  my %args = (
    token       => undef,
    @_
  );

  my $dns_uri = $self->dns_uri;
  $dns_uri->path('webservice/rest/server.php');
  $dns_uri->query_form( {
    wstoken   => $args{token},
    wsfunction => 'core_role_get_all_roles',
    moodlewsrestformat => $REST_FORMAT,
  } );

  my $res = $self->rest_call($dns_uri);
  my $ra_roles = from_json($res->content);

say '=====================================================';
use Data::Dumper;
say Dumper $ra_roles;

  my $rh_student_role = first { $_->{shortname} eq 'student' } @$ra_roles;
  return $rh_student_role;
}

sub get_user {
  my $self = shift;
  my %args = (
    token    => undef,
    username => undef,
    @_
  );
  my $ra_users = $self->get_users( token => $args{token} );
  my $user = first { $_->{username} eq $args{username} } @$ra_users;
  unless ($user) {
    ouch 'MSE-0003', "failed to find user '$args{username}'";
  }
  return $user;
}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::Moodle::Simple - Client API and CLI for Moodle Web Services

=head1 SYNOPSIS

  use WebService::Moodle::Simple;

=head1 DESCRIPTION

WebService::Moodle::Simple is

=head1 AUTHOR

Andrew Solomon E<lt>andrew@geekuni.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Andrew Solomon

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
