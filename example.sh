#!/usr/bin/env bash
set -e

# Perform some file descriptor redirection so that we have
# greater control over what is displayed to the screen.
# Direct fd 3 to stdio
exec 3>&1
# Direct stdio to /dev/null
exec 1>/dev/null
# Direct fd 4 to stderr
exec 4>&2
# Direct stderr to /dev/null
exec 2>/dev/null

# Given the fd redirection above, print() will always display output
# to stdio.
function print() {
  >&3 echo "$@"
}

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

# If the verbose option is specified, then we point
# the original stdio and stderr descriptors back to
# their original files.
if [ "$verbose" = true ]; then
  # Restore fd 1 to fd 3 (stdio now)
  exec 1>&3
  # Direct fd 2 to fd 4 (stderr now)
  exec 2>&4
fi

# deprecated_method:
#   Echo's out a message to stderr, but still returns
#   a "happy" exit code. The warning should only display
#   when verbose mode is set.
function deprecated_method() {
  >&2 echo "WARN: this method is deprecated"
  return 0
}

# This should always print to the screen since it's using our special "print" method.
print "Begin."

# $foo should still receive 55 in non-verbose mode, despite fd reassignment.
foo="$(echo "55")"
# This should always print "foo: 55"
print "foo: $foo"

# This should only print in verbose mode since it's a normal 'echo'.
echo "Hello from echo!"

# This method should only print its deprecation warning when in verbose mode.
deprecated_method

# done.
print "Finished."
