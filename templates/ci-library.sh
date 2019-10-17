#!/bin/bash
# Adapted from msys2
# Enable colors
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
cyan=$(tput setaf 6)

# Basic status function
_status() {
    local type="${1}"
    local status="${package:+${package}: }${2}"
    local items=("${@:3}")
    case "${type}" in
        failure) local nameref_color="${red}";   title='[MSYS2 CI] FAILURE:' ;;
        success) local nameref_color="${green}"; title='[MSYS2 CI] SUCCESS:' ;;
        message) local nameref_color="${cyan}";  title='[MSYS2 CI]'
    esac
    printf "\n${nameref_color}${title}${normal} ${status}\n\n"
    printf "${items:+\t%s\n}" "${items:+${items[@]}}"
}

# Convert lines to array
_as_list() {
    local filter="${2}"
    local strip="${3}"
    local lines="${4}"
    local result=1
    local nameref_list=()
    while IFS= read -r line; do
        test -z "${line}" && continue
        result=0
        [[ "${line}" = ${filter} ]] && nameref_list+=("${line/${strip}/}")
    done <<< "${lines}"
    eval $1=\$nameref_list
    return "${result}"
}

# Changes in latest commit
_list_changes() {
    local list_name="${1}"
    local filter="${2}"
    local strip="${3}"
    local git_options=("${@:4}")
    _as_list "${list_name}" "${filter}" "${strip}" "$(git log "${git_options[@]}" HEAD^.. | sort -u)"
}

# List commits
list_commits()  {
    _list_changes commits '*' '#*::' --pretty=format:'%ai::[%h] %s'
}

# Changed packages
list_packages() {
    _list_changes packages 'packages/*' 'packages/' --pretty=format: --name-only || return 1
}

# Status functions
failure() { local status="${1}"; local items=("${@:2}"); _status failure "${status}." "${items[@]}"; exit 1; }
success() { local status="${1}"; local items=("${@:2}"); _status success "${status}." "${items[@]}"; exit 0; }
message() { local status="${1}"; local items=("${@:2}"); _status message "${status}"  "${items[@]}"; }
