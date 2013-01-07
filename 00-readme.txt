TAG=4.7.0.6
SCR=stability-infrastructure

### Patch application

# It is helpful to retain information in the log on conflicts or backporting changes
# you have to make.

# Edit NEWS, then autogen NEWS.stability and commit both.
# You can do this whenever you want, but it should at least be
# done directly before a release.  $SCR/generate-patchlog displays
# a list of applied patches, as a starting point.
vi NEWS
$SCR/update-news

###

# Test the release.  This is unfortunately not automated
# Generally, you have to build and install into normal or temp prefix,
#   then run the tests; the test suite is broken and won't run
#   properly if chicken is not installed (error in setup-download).
#   `make check` uses the PREFIX you specified in `make;make install`
#   so installing to a temp prefix will work.

# Ensure you update the NEWS file (see above).

# Tag new release (updates version info, generates NEWS.stability patchlog, creates signed tag)
$SCR/tag $TAG

# Push to call-cc and possibly github
# (NB mention `git remote add` in init section)
git push call-cc stability/4.7.0 tag $TAG

# Generate a release tarball and md5sum, test it
release.sh

# upload tarball
# See zbigniew@call-cc:chicken-infrastructure/doc/release-steps.
# Tarballs should now go in /var/www/apache/code/releases/x.y.z --
#   not sure if they should be mirrored in stability dir anymore.

# Update download page
# (hand svn edit of wiki/stability)
# (future: edit zbigniew@call-cc:~/chicken-infrastructure/code/index.wiki, make (to copy file), commit and push)
