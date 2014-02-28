# NAME

WebService::Moodle::Simple - Client API and CLI for Moodle Web Services

# SYNOPSIS

    moodlews login        - login with your Moodle password and retrieve token
    moodlews add_user     - Create a Moodle user account
    moodlews get_users    - Get all users
    moodlews enrol        - Enrol user into a course
    moodlews set_password - Update a user account password


    use WebService::Moodle::Simple;

    my $moodle = WebService::Moodle::Simple->new(
      domain   =>  moodle.example.edu,
      target   =>  example_webservice
    );

    my $rh_token = $moodle->login( username => 'admin', password => 'foobar');


# DESCRIPTION

WebService::Moodle::Simple is a CLI and API interface to Moodle's Web Service interface.

__THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE__.

# AUTHOR

Andrew Solomon <andrew@geekuni.com>

# COPYRIGHT

Copyright 2014- Andrew Solomon

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
