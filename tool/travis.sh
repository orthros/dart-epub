#!/bin/bash

# Fast fail the script on failures.
set -e

# Analyze the code.
dartanalyzer --strong --fatal-warnings \
  lib/epub.dart \
  lib/src/epub_reader.dart

# Test the entire test directory
pub run test test/