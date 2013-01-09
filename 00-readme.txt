    SCR=stability-infrastructure

# Initialization

    git clone git://code.call-cc.org/chicken-core chicken-core-stability-4.8
    cd chicken-core-stability-4.8
    git remote add call-cc <USER>@call-cc:/usr/local/repos/chicken-core.git
    git clone git://github.com/ursetto/stability-infrastructure.git
    git checkout -b stability/4.8.0 4.8.0

I prefer to use `origin` as a read-only copy and set up remote `call-cc` as
writable, to avoid accidents.  The upload examples assume remote `call-cc` exists.

Ensure authorship of patches is correct:

    git config user.name  "M. Y. Croft"
    git config user.email "my@croft.com"

**FIXME** Modify make file or copy from make.example

    cp $SCR/make.example $SCR/make

FIXME If you want to build and test incrementally, you should set PREFIX to
a temp location (i.e. don't overwrite a working chicken install).
`make check` unfortunately requires that the tested Chicken has been 
installed into PREFIX.

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

Edit NEWS, then autogen NEWS.stability and commit both.
You can do this whenever you want, but it should at least be
done directly before a release.  $SCR/generate-patchlog displays
a list of applied patches, as a starting point.

    vi NEWS
    $SCR/update-news

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

Ensure you update the NEWS file (see above).

Tag new release (updates version info, generates NEWS.stability patchlog, creates signed tag):

    $SCR/tag $TAG

# Generate the release files

Generate a release tarball and md5sum, test it

    $SCR/release

# Push updates to call-cc repository

You can push any time you are confident the patches have tested safe
and won't change; but you definitely have to push when you make a
release!

**FIXME** First push may need stability/4.8.0:stability/4.8.0.  And after?  
**FIXME** We don't have a script for this.

    git push call-cc stability/4.8.0 tag $TAG

# Upload tarball

See zbigniew@call-cc:chicken-infrastructure/doc/release-steps.

Tarballs should now go in /var/www/apache/code/releases/x.y.z --
not sure if they should be mirrored in stability dir anymore.

# Update download page

The main download page on code.call-cc.org must be updated manually.  The releases page itself is a directory listing and does *not* need to be updated.  

(future: edit zbigniew@call-cc:~/chicken-infrastructure/code/index.wiki, make (to copy file), commit and push)
