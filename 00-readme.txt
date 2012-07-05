TAG=4.7.0.6

# Test the release.  This is unfortunately not automated
# Generally, you have to build and install into normal prefix,
#   then run the tests; the test suite is broken and won't run
#   properly if chicken is not installed.  PATH may need to be
#   set so installed (testing) chicken is first.


# Update documentation (NEWS, NEWS.stability, README, manual/The User's Manual) 
#  with new version number, and commit  [see ./tag for an example]


# Tag new release (updates buildversion, version.scm, and creates annotated tag)
tag $TAG


# Upload to call-cc and possibly github
git push call-cc stability/4.7.0 tag $TAG


# Generate a release tarball and md5sum, test it, and upload it
release.sh

