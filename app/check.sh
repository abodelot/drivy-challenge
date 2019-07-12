#!/bin/sh

set -e

cd ../level$1
ruby main.rb
diff data/output.json data/expected_output.json
