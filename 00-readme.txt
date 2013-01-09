    TAG=4.7.0.6
    SCR=stability-infrastructure

# Initialization

    git clone git://code.call-cc.org/chicken-core chicken-core-stability-4.8
    cd chicken-core-stability-4.8
    git checkout -b stability/4.8.0 4.8.0
    git clone git://github.com/ursetto/stability-infrastructure.git

Ensure authorship is correct in `[user]` section of `.git/config`.

If you want to build and test incrementally, you should set PREFIX to
a temp location (i.e. don't overwrite a working chicken install).
`make check` unfortunately requires that the tested Chicken has been 
installed into PREFIX.

    cp $SCR/make.example $SCR/make

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

# Test the release.

    $SCR/build
    $SCR/make-dist
    $SCR/test-dist

Ensure you update the NEWS file (see above).

Tag new release (updates version info, generates NEWS.stability patchlog, creates signed tag):

    $SCR/tag $TAG

Push to call-cc and possibly github
(NB mention `git remote add` in init section)

    git push call-cc stability/4.7.0 tag $TAG

Generate a release tarball and md5sum, test it

    $SCR/release

# Upload tarball

See zbigniew@call-cc:chicken-infrastructure/doc/release-steps.

Tarballs should now go in /var/www/apache/code/releases/x.y.z --
not sure if they should be mirrored in stability dir anymore.

# Update download page

(hand svn edit of wiki/stability)

(future: edit zbigniew@call-cc:~/chicken-infrastructure/code/index.wiki, make (to copy file), commit and push)
