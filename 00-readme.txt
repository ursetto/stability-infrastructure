TAG=4.7.0.6

# Test the release.  This is unfortunately not automated
# Generally, you have to build and install into normal or temp prefix,
#   then run the tests; the test suite is broken and won't run
#   properly if chicken is not installed (error in setup-download).
#   `make check` uses the PREFIX you specified in `make;make install`
#   so installing to a temp prefix will work.

# Update documentation (NEWS, NEWS.stability, README, manual/The User's Manual) 
#  with new version number, and commit  [see ./tag for an example]


# Tag new release (updates buildversion, version.scm, and creates annotated tag)
tag $TAG


# Upload to call-cc and possibly github
git push call-cc stability/4.7.0 tag $TAG


# Generate a release tarball and md5sum, test it, and upload it
release.sh

