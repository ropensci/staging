# Staging Scripts

Azure Pipeline scripts adapted from [r-azure-pipelines](https://github.com/r-lib/r-azure-pipelines) to build and test package monorepos.

## How to use

In your monorepo, create a file `azure-pipelines.yml` containing this:

```yaml
# Use template from https://github.com/ropensci/staging
resources:
  repositories:
    - repository: staging
      type: github
      name: ropensci/staging
      endpoint: r-universe

jobs:
  - template: azure-staging.yml@staging

```

And then enable the pipeline for this repo in the azure dashboard.

## Why

Building all packages in a single repo allows to:

 - Test against staging versions of all packages
 - Without having to rely on 'remotes'
 - Use global package library cache in CI
 - Not worry about race conditions when updating PACKAGES index

