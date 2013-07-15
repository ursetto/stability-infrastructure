#!/bin/bash

# Example bisect script used to track down ticket #1021 via `git bisect`
# Usage: `git bisect run ./test-1021.sh`

set -e

rm -rf inst

make PLATFORM=macosx spotless

# Possible LLVM hotfix
# (cd ~/scheme/chicken-core && git show 55bce3a0a) | git apply || true
git cherry-pick -n 55bce3a0a || true

make PLATFORM=macosx CHICKEN=$HOME/tmp/chicken-4.7.4/inst/bin/chicken ARCH=x86 C_COMPILER_OPTIONS="-no-cpp-precomp -fno-strict-aliasing -fwrapv -fno-common -DHAVE_CHICKEN_CONFIG_H -m32" ASSEMBLER_OPTIONS="-m32" LINKER_OPTIONS="-m32" PREFIX=$PWD/inst install

# Don't abort on csi bus error (squash rc > 127 to 1)
rc=0
inst/bin/csi -v || rc=1

git reset --hard           # Ensure tree is clean after hotfix

exit $rc
