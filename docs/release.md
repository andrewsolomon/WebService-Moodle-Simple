# Releasing to CPAN

Releases are built and uploaded with Dist::Zilla (`dist.ini`).

## One-off setup

    cpanm Dist::Zilla
    dzil authordeps --missing | cpanm
    dzil listdeps --missing | cpanm

Uploading needs PAUSE credentials in `~/.pause`:

    user     YOURPAUSEID
    password yourpassword

## Versions

- `[Git::NextVersion]` takes the next version from the latest git tag, so
  after the tag `v0.06` it builds `0.07`. Set `V=x.yy` to override it.
- `$VERSION` in `lib/WebService/Moodle/Simple.pm` is set by hand.
  `[PkgVersion]` skips the module because it already assigns `$VERSION`, so
  update it to match the release.

## Steps

1. Add the release notes to `Changes` under `{{$NEXT}}`. Don't write the
   version or date: `[NextRelease]` fills them in.
2. Set `$VERSION` in `lib/WebService/Moodle/Simple.pm`.
3. Run the unit tests and the integration tests (see
   [development.md](development.md)):

       prove -rlv t

4. Build and check the result:

       dzil build

   - `README.pod` is regenerated in the repository root. Check its diff and
     commit it, because the release refuses to run with it uncommitted.
   - In the build directory, check `Changes`, `MANIFEST` (no `AGENTS.md`,
     `docs/` or `dist.ini`) and that `META.yml` has a `resources:
     repository` link to GitHub.

   Then remove the build with `dzil clean`.

5. With a clean working tree, release:

       dzil release

   This runs the tests in the built dist, asks for confirmation, and uploads
   to PAUSE. Then `[@Git]` commits `Changes` (now with the version and date,
   and a new `{{$NEXT}}`), tags the release `vx.yy`, and pushes the branch
   and tag to `origin`.

6. Check the release on MetaCPAN once it's indexed: the abstract, the
   repository link and the POD.
