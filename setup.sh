#!/usr/bin/env bash

# install
# bash <(curl -fsSL "https://raw.githubusercontent.com/softvisio/deb/main/setup.sh") install

# remove
# bash <(curl -fsSL "https://raw.githubusercontent.com/softvisio/deb/main/setup.sh") remove

set -Eeuo pipefail
trap 'echo -e "⚠  Error ($0:$LINENO): $(sed -n "${LINENO}p" "$0" 2> /dev/null | grep -oE "\S.*\S|\S" || true)" >&2; return 3 2> /dev/null || exit 3' ERR

repo_name=softvisio
repo_slug=softvisio/deb
component=main
version_id=$(. /etc/os-release && echo $VERSION_ID)

function _remove() {
    rm -rf /usr/share/keyrings/${repo_name}-archive-keyring.gpg
    rm -rf /etc/apt/sources.list.d/${repo_name}.list

    apt-get clean all

}

function _install() {
    apt-get install -y gpg

    curl -fsSL "https://raw.githubusercontent.com/$repo_slug/main/public-key.asc" | gpg --dearmor -o "/usr/share/keyrings/${repo_name}-archive-keyring.gpg"

    # deb [trusted=yes] https://raw.githubusercontent.com/$repo_slug/ $version_id $component

    cat << EOF > "/etc/apt/sources.list.d/${repo_name}.list"
deb [signed-by=/usr/share/keyrings/${repo_name}-archive-keyring.gpg] https://raw.githubusercontent.com/$repo_slug/ $version_id $component
EOF

}

case "${1:-}" in
    install)
        _remove
        _install
        ;;

    remove)
        _remove
        ;;

    *)
        return 1
        ;;
esac
