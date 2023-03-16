#!/bin/sh

set -e

# This is a workaround for a security fix in git that prevents a user from accessing an untrusted workspace
git config --global --add safe.directory /github/workspace

git fetch --tags
# This suppress an error occurred when the repository is a complete one.
git fetch --prune --unshallow || true

latest_tag=$(git tag -l --sort=version:refname | sed '$!d')

echo "Found latest tag: ${latest_tag}"

if [ "${latest_tag}" = '' ] && [ "${INPUT_WITH_INITIAL_VERSION}" = 'true' ]; then
  latest_tag="${INPUT_INITIAL_VERSION}"
fi

echo "tag=${latest_tag}" >> $GITHUB_OUTPUT
