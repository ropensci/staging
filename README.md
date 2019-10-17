# Staging Scripts

Azure Pipeline scripts adapted from [r-azure-pipelines](https://github.com/r-lib/r-azure-pipelines) to build and test package monorepos.

## Why

Building all packages in a single repo allows to:

 - Test against staging versions of all packages
 - Without having to rely on 'remotes'
 - Use global package library cache in CI
 - Not worry about race conditions when updating PACKAGES index

