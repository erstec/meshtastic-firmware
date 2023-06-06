#!/usr/bin/env bash

# Note: This is a prototype for how we could add static code analysis to the CI.

set -e

VERSION=`bin/buildinfo.py long`

# The shell vars the build tool expects to find
export APP_VERSION=$VERSION

if [[ $# -gt 0 ]]; then
    # can override which environment by passing arg
    BOARDS="$@"
else
    BOARDS="tlora-v2-1-1.6 tlora-v2-1-1.6_lifepo4 tbeam tbeam_lifepo4"
fi

echo "BOARDS:${BOARDS}"

CHECK=""
for BOARD in $BOARDS; do
     CHECK="${CHECK} -e ${BOARD}"
done

pio check --flags "-DAPP_VERSION=${APP_VERSION} --suppressions-list=suppressions.txt" $CHECK --skip-packages --pattern="src/" --fail-on-defect=low --fail-on-defect=medium --fail-on-defect=high
