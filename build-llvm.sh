#make PLATFORM=macosx C_COMPILER=gcc-4.2 NURSERY=1048576 CHICKEN=$HOME/local/chicken-4.7.0/bin/chicken PREFIX=$HOME/local/chicken-4.7.0-st "$@"
make PLATFORM=macosx NURSERY=1048576 CHICKEN=$HOME/local/chicken-4.7.0-st-llvm/bin/chicken PREFIX=$HOME/local/chicken-4.7.0-st-llvm "$@"
