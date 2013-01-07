#!/bin/sh
#/ Usage: $0 TAG
#/   Update Chicken version number to $TAG, write patchlog to 
#/   NEWS.stability, commit changes and create signed tag $TAG.
#/
#/   Call from the top directory of a checked-out stability/* branch.
#/   Also, update and commit NEWS prior to calling.
#/
#/   If this crashes, you should `git reset --hard HEAD`.

set -e
die() { echo "$@" >&2; exit 1; }
usage() { grep ^#/ $0 | cut -c4-; exit 1; }

IAM=$(which $0)
SCRIPTDIR=${IAM%/*}

TAG="$1"
[ -z "$TAG" ] && usage

[ -d ".git" ] \
   || die "Run this from the top level of the stability git repository"
[[ "stability" == $(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3) ]] \
   || die "A stability/ branch must be checked out"   # we don't check tag corresponds, though
git show-ref --tags "$TAG" >/dev/null \
   && die "Tag $TAG already exists"
[[ -z $(git status --porcelain --untracked-files=no) ]] \
   || die "Commit all pending changes first"

$SCRIPTDIR/update-version "$TAG"
git add buildversion
git add version.scm || true           # Not needed if >= 4.8.

$SCRIPTDIR/generate-patchlog "$TAG" > NEWS.stability
git add NEWS.stability

git diff --cached
echo
git commit -v -m "Version $TAG"
git tag -s "$TAG" -m "Version $TAG"
echo "Tagged version $TAG"

# note: you must push the tag explicitly; see ./push
# e.g. git push call-cc stability/4.7.0 tag $TAG
