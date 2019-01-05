#!/bin/bash
export TERM="${TERM:-xterm}"
source "${BASH_SOURCE%/*}/ci-library.sh"

# Detect changed packages
list_commits  || failure 'Could not detect added commits'
list_packages || failure 'Could not detect changed files'
message 'Processing changes' "${commits[@]}"
test -z "${packages}" && success 'No changes in package recipes'

# Print updated packages
message "Building package(s): ${packages}"
for package in "${packages[@]}"; do
    orig_url=$(head -1 "packages/${package}")
    orig_name=$(basename $orig_url)
    rm -Rf "build-$package" && mkdir "build-$package" && cd "build-$package"
    curl -LSsk $orig_url -o $orig_name
    mkdir -p upstream
    tar xf $orig_name -C upstream --strip-components=1
    R CMD build upstream --no-build-vignettes --no-manual
    rm -Rf upstream $orig_name
    Rscript --vanilla -e "tools::write_PACKAGES(verbose = TRUE)"
    cd -
done
