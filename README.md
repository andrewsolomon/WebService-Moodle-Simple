# NAME

WebService::Moodle::Simple - Client API and CLI for Moodle Web Services

# SYNOPSIS

## CLI

    moodlews login        - login with your Moodle password and retrieve token
    moodlews add_user     - Create a Moodle user account
    moodlews get_users    - Get all users
    moodlews enrol        - Enrol user into a course
    moodlews set_password - Update a user account password

## API

    use WebService::Moodle::Simple;

    my $moodle = WebService::Moodle::Simple->new(
      domain   =>  moodle.example.edu,
      target   =>  example_webservice
    );

    my $rh_token = $moodle->login( username => 'admin', password => 'foobar');

# DESCRIPTION

WebService::Moodle::Simple is Client API and CLI for Moodle Web Services

\_\_THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE\_\_.

# USAGE

## CLI

Get instructions on CLI usage

    moodlews

## Example - Login and Get Users

    moodlews login -u admin -d moodle.example.edu -p foobar -t example_webservice

Retrieve the user list using the token returned from the login command

    moodlews get_users -o dnur823r -d moodle.example.edu -t example_webservice

## Unit Tests

    prove -rlv t

### Full Unit Tests

    TEST_WSMS_ADMIN_PWD=foobar \
    TEST_WSMS_DOMAIN=moodle.example.edu \
    TEST_WSMS_TARGET=example_webservice prove -rlv t

\_\_NOTE: Full unit tests write to Moodle Database - only run then against a test Moodle server\_\_.

# AUTHOR

Andrew Solomon <andrew@geekuni.com>

# COPYRIGHT

Copyright 2014- Andrew Solomon

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
