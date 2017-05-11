#!/bin/bash

# Fast fail the script on failures.
set -e

# Analyze the code.
dartanalyzer --fatal-warnings \
  lib/dartpub.dart \
  lib/src/epubReader.dart

# Run the tests.
dart -c test/enum_string_test.dart