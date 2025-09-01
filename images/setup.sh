#!/usr/bin/env bash

set -Eeuo pipefail
trap 'echo -e "⚠  Error ($0:$LINENO): $(sed -n "${LINENO}p" "$0" 2> /dev/null | grep -oE "\S.*\S|\S" || true)" >&2; return 3 2> /dev/null || exit 3' ERR

apt-get update

apt-get install -y curl

script=$(curl -fsSL "https://raw.githubusercontent.com/softvisio/scripts/main/setup-host.sh")
source <(echo "$script")

apt-get install -y \
    apt-utils git gcc g++ make cmake libssl-dev gpg
