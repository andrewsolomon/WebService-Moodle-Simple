# AGENTS.md

Guidance for using Claude (or other coding agents) to edit WebService-Moodle-Simple.

## Project Notes

- Perl client API and CLI (`moodlews`) for Moodle Web Services.
- Built with Dist::Zilla (`dist.ini`, `@Basic` plus PodWeaver). `README.pod` is generated from the main module's POD by `[ReadmeAnyFromPod]`; edit the POD in `lib/WebService/Moodle/Simple.pm` and rebuild rather than editing `README.pod` by hand.
- Run the unit tests with `prove -rlv t`.
- The full tests (those needing `TEST_WSMS_*` environment variables) write to a real Moodle database. Only run them against a test Moodle server, and never without being told to.

## Development Principles

- Prefer simple, readable, maintainable solutions.
- Avoid unnecessary abstractions, dependencies, and complexity.
- Make the smallest change that satisfies the requirements.
- Reuse existing functionality rather than duplicating it.
- Follow the project's established architectural patterns.
- Do not introduce speculative functionality or handle hypothetical edge cases unless required.

## Working with Existing Code

- Understand the relevant code before modifying it.
- Preserve existing behaviour unless a change is explicitly required.
- Do not refactor unrelated code.
- Avoid changing public interfaces unnecessarily.
- Ask for clarification when requirements are materially ambiguous.

## Dependencies and Security

- Prefer existing dependencies.
- Do not introduce new dependencies without justification.
- Never commit credentials, tokens, or other secrets.
- Do not weaken security controls to resolve implementation problems.

## Testing

- Run relevant existing tests after making changes.
- Add or update tests for changed behaviour.
- Avoid introducing elaborate test infrastructure for simple functionality.
- Do not modify tests merely to make a failing implementation pass.
- Report any tests that could not be run.

## Documentation

- Keep documentation concise and focused on important concepts.
- Document why a non-obvious decision was made, rather than explaining self-evident code.
- Avoid lengthy descriptions of trivial implementation details.
- Update existing documentation when behaviour changes.
- Do not create additional documentation files unless they serve a clear purpose.
