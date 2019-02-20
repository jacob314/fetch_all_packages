#!/bin/bash
set -ex

export PATH=~/development/flutter/bin:$PATH

if [[ "$SHARD" == "dartfmt" ]]; then
 echo 'Formating code'
 flutter format . || exit $?
else
  flutter --no-color test --machine --start-paused test/titled_page_view_test.dart || exit $?
fi
