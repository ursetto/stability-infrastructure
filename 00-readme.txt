    SCR=stability-infrastructure

# Initialization

    git clone git://code.call-cc.org/chicken-core chicken-core-stability-4.8
    cd chicken-core-stability-4.8
    git remote add call-cc <USER>@call-cc:/usr/local/repos/chicken-core.git
    git clone git://github.com/ursetto/stability-infrastructure.git
    git checkout -b stability/4.8.0 4.8.0
    # or, if stability/4.8.0 branch already exists:
    git checkout -b stability/4.8.0 4.8.0

I prefer to use `origin` as a read-only copy and set up remote `call-cc` as
writable, to avoid accidents.  The `push` script assumes remote `call-cc` exists.

Ensure authorship of patches is correct:

    git config user.name  "M. Y. Croft"
    git config user.email "my@croft.com"

Create your `make` command, which should be a shell script wrapping a call to
`make` with needed arguments such as PLATFORM.  An example is provided.

    cp $SCR/make.example $SCR/make
    vi $SCR/make

# Patch application

Cherry pick patches.  Currently just does `git cherry-pick -x`.

    $SCR/cherry-pick <commitid> ...

If there is e.g. a NEWS file updated that you don't want to merge in,
cherry pick the patch without committing, undo the NEWS change and commit.
To avoid changing authorship, use -c option when committing
(however, this will also discard "Conflict" info added by cherry-pick).

    $SCR/cherry-pick -n <commitid>
    git reset NEWS
    git checkout -- NEWS
    git commit -c <commitid>

If a cherry pick fails and you can't resolve it and want to return
to the prior state of the tree:

    git reset --merge HEAD

It is helpful to retain information in the log on conflicts,
backporting changes or related notes.

# Test incrementally

This section is incomplete.  See the next section for full build testing.

Safely doing incremental build and test is a bit involved, and I found it
acceptable enough so far to do a full build & test run periodically.

# Test full build as needed

Easiest way to test:

    $SCR/release

which builds from scratch, makes a distribution tarball, builds that and tests it
with `make check`.  It doesn't upload anything, so it's safe to run repeatedly.

In other words, it does:

    $SCR/build
    $SCR/make-dist
    $SCR/test-dist

Now add more patches, or prepare for release.

# Release preparation

Below, `$TAG` denotes the version number you intend to release.

    TAG=4.8.0.1

Update `NEWS` and commit it.  This will also generate and commit
`NEWS.stability` at the same time.

    vi NEWS
    $SCR/update-news

You can update the news whenever you want, but it should always be done
directly before a release.  `$SCR/generate-patchlog` displays a list of applied
patches to stdout, which may help when compiling `NEWS`.

Tag the new release.

    $SCR/tag $TAG

Tagging will:

- Update the Chicken version to `$TAG`. We bump the version at release time; don't update `buildversion` manually.
- Generate the `NEWS.stability` patchlog (redundant, if you used `update-news` in the last step)
- Create a signed, annotated tag.  Annotated tags play better with `git describe`.  Signed keys use your GPG key to sign the commit object; there's no official Chicken GPG signing key yet, so edit the script to use `tag -a` if you have no GPG key.

# Generate the release files

Build Chicken from scratch, make a distribution tarball and md5sum it, extract and build
the tarball, and test it with `make check`:

    $SCR/release

# Push updates to call-cc repository

You can push any time you are confident the patches have tested safe
and won't change; but you definitely have to push when you make a
release!

Ensure the stability branch is checked out and:

    ./push $TAG

$TAG should be the release TAG.  You can omit $TAG if you are not pushing a
release.  

# Upload tarball

See zbigniew@call-cc:chicken-infrastructure/doc/release-steps.

Tarballs should now go in /var/www/apache/code/releases/x.y.z --
not sure if they should be mirrored in stability dir anymore.

# Update download page

The main download page on code.call-cc.org must be updated manually.  The releases page itself is a directory listing and does *not* need to be updated.  

(future: edit zbigniew@call-cc:~/chicken-infrastructure/code/index.wiki, make (to copy file), commit and push)
