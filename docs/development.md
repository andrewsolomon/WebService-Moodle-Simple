# Development

WebService::Moodle::Simple is a Perl client for Moodle Web Services, with a
CLI (`bin/moodlews`). It supports Moodle 3.2 and Moodle 5.3.

The method reference is the POD in `lib/WebService/Moodle/Simple.pm`
(`perldoc lib/WebService/Moodle/Simple.pm`). `README.pod` is generated from
that POD at build time, so edit the module, not `README.pod`.

## Layout

- `lib/WebService/Moodle/Simple.pm`: the client. Every call is an HTTP POST
  of form data, either to `webservice/rest/server.php` (REST functions) or to
  `login/token.php` (`check_password`). Moodle 5.3 rejects credentials sent in
  the query string.
- `lib/WebService/Moodle/Simple/CLI.pm`: `moodlews` options and subcommands
  (OptArgs). Each subcommand's `run` is in `lib/WebService/Moodle/Simple/CLI/`.
- `t/`: tests (see below).

## Setup

Install the runtime and test dependencies listed in `cpanfile`:

    cpanm --installdeps .

To build or release you also need the Dist::Zilla plugins (see
[release.md](release.md)).

## CLI

    ./bin/moodlews --help

Commands: `add_user`, `get_user`, `set_password`, `check_password`,
`suspend` (`--undo` to unsuspend), `enrol`. Every command needs the server
(`-d`) and the web service token (`-o`). For example:

    ./bin/moodlews get_user -u freddy -d moodle.example.com -o 0123456789abcdef

## Unit tests

    prove -rlv t

These need no Moodle server. `t/10_mock.t` replaces the HTTP layer with
canned Moodle responses, so it checks what is sent (POST, form fields) and
how responses from both Moodle 3.2 and 5.3 are interpreted. `t/20_live.t` is
skipped unless the variables below are set.

## Integration tests

`t/20_live.t` runs every method against a real Moodle server. It creates a
user (`test_<timestamp>`), changes its password, suspends and unsuspends it,
and enrols it in a course.

**It writes to the Moodle database. Only run it against a test Moodle
server.**

    TEST_WSMS_SCHEME=https \
    TEST_WSMS_DOMAIN=moodle.example.com \
    TEST_WSMS_PORT=443 \
    TEST_WSMS_TARGET=example_webservice \
    TEST_WSMS_TOKEN=0123456789abcdef \
    TEST_WSMS_COURSE=example-short-course-name \
    prove -lv t/20_live.t

The test server needs:

- Web services and the REST protocol enabled.
- An external service (`TEST_WSMS_TARGET`) containing
  `core_user_create_users`, `core_user_get_users_by_field`,
  `core_user_update_users`, `core_course_get_courses` and
  `enrol_manual_enrol_users`, with a token (`TEST_WSMS_TOKEN`) for a user
  allowed to call them.
- The mobile web service enabled (`enablemobilewebservice`), which
  `check_password` uses through the `moodle_mobile_app` service.
- A course with the short name `TEST_WSMS_COURSE` that uses manual
  enrolment, and a student role with id 5 (hard-coded in `enrol_student`).

Before a release, run it against every Moodle version the client supports.
