#!/usr/bin/env bash

if [[ "$TRAVIS_PULL_REQUEST" != 'false' ]]; then
  exit 0
fi

if [[ "$TRAVIS_BRANCH" = 'master' ]]; then
  mvn -V -B -s travis/settings.xml clean deploy -DskipTests
  exit 0
fi

if [[ "$TRAVIS_BRANCH" =~ ^(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)$ ]]; then
  openssl aes-256-cbc -K $encrypted_b90015baf6e6_key -iv $encrypted_b90015baf6e6_iv -in travis/codesigning.asc.enc -out travis/codesigning.asc -d
  gpg --fast-import travis/codesigning.asc
  mvn -V -B -s travis/settings.xml clean deploy -P sign -DskipTests
  exit 0
fi

echo "Branch $TRAVIS_BRANCH not eligible for deployment."
