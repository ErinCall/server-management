#!/bin/bash

set -e
echo "Updating cabal"
cabal update
echo "setting up cabal sandbox"
cabal sandbox init
echo "Building dependencies; see $PWD/build.out for stdout and $PWD/build.err for stderr"
cabal install --only-dependencies --force-reinstall 1> build.out 2> build.err
echo "Building app; see $PWD/build.out for stdout and $PWD/build.err for stderr"
cabal build 1>> build.out 2>> build.err
