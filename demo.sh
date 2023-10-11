#!/usr/bin/env bash
set -e

source ./lib/verbose-module

verbose=false

# Parse options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -v|--verbose)
        verbose=true
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
  esac
  shift
done

# Set verbosity mode
if [ "$verbose" = "true" ]; then
  enable_verbose_mode
else
  disable_verbose_mode
fi

# Make some noise...



# This should always print to the screen since it's using our special "shout" method.
shout "Begin."

# This should always print "foo: 55"
foo="$(echo "55")"
shout "foo: $foo"

# This should only print in verbose mode since it's a normal 'echo'.
echo "Hello from echo!"

# deprecated_method:
#   Echo's out a message to stderr, but still returns
#   a "happy" exit code. The warning should only display
#   when verbose mode is set.
function deprecated_method() {
  >&2 echo "WARN: this method is deprecated"
  return 0
}

# This method should only print its deprecation warning when in verbose mode.
deprecated_method

# done.
shout "Finished."
