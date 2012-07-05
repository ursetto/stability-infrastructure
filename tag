#!/bin/sh

# Set buildversion and version.scm to version $1, commit and create signed tag $1.

# Prior to calling, you should update version nos. in docs and make a separate commit
# for it (as it is not done automatically):
#   git add NEWS NEWS.stability README manual/The\ User\'s\ Manual
#   git commit -m 'Update version number in documentation'

die() {
      echo "$@" >&2
      exit 1
}

TAG="$1"
FILES="buildversion version.scm NEWS.stability"

[ -n "$TAG" ] \
   || die "Usage: $0 TAG \n   Ex: $0 4.7.0.3-st"
[ -d ".git" ] \
   || die "Run this from the top level of the stability git repository"
[[ "stability" == $(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3) ]] \
   || die "A stability/ branch must be checked out"   # we don't check tag corresponds, though
git show-ref --tags "$TAG" >/dev/null \
   && die "Tag $TAG already exists"
[[ -z $(git status --porcelain --untracked-files=no) ]] \
   || die "Commit all pending changes first"

printf "$TAG" > buildversion \
   || die
printf '(define-constant +build-version+ "%s")\n' "$TAG" > version.scm \
   || die
git add $FILES \
   || die
git diff --cached \
   || die
echo
git commit -v -m "Version $TAG" \
   || die
git tag -s "$TAG" -m "Version $TAG" \
   || die
echo "Tagged version $TAG"

# note: you must push the tag explicitly; see ./push
# e.g. git push call-cc stability/4.7.0 tag $TAG
