#!/bin/bash

# Fast fail the script on failures.
set -e

# Analyze the code.
dartanalyzer --fatal-warnings \
  lib/epub.dart \
  lib/src/epubReader.dart

# Run the tests.
#dart -c test/enum_string_test.dart
#dart -c test/epub_reader_tests.dart