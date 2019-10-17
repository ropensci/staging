#!/bin/bash
#set -e
export TERM="${TERM:-xterm}"
scripts="${BASH_SOURCE%/*}"
source "${scripts}/ci-library.sh"

# Find packages updated in this commit:
packages=$(git log  --pretty=format: --name-only HEAD^.. | grep "^[^.]")
message "Building package(s): ${packages}"

# Build and check the packages
for pkg in "${packages[@]}"; do
  git submodule update --init --remote "${pkg}"
  echo "^\\.git" >> "${pkg}/.Rbuildignore"
  Rscript --vanilla "${scripts}/install_deps.R" "${pkg}"
  R CMD build "${pkg}"
  R CMD check --install-args="--build" --no-manual --no-build-vignettes ${pkg}_*.tar.gz
done
