#!/bin/sh

set -e

git fetch --tags
# This suppress an error occurred when the repository is a complete one.
git fetch --prune --unshallow || true

latest_tag=$(git tag -l --sort=taggerdate | sed '$!d')

echo "Found latest tag: ${latest_tag}"

if [ "${latest_tag}" = '' ] && [ "${INPUT_WITH_INITIAL_VERSION}" = 'true' ]; then
  latest_tag="${INPUT_INITIAL_VERSION}"
fi

echo "::set-output name=tag::${latest_tag}"
