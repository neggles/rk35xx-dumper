#!/usr/bin/env bash
set -euo pipefail

toolchain_release='15.0.2'
host_arch=$(uname -m)

# assemble archive name and URL
toolchain_archive="LLVMEmbeddedToolchainForArm-${toolchain_release}-Linux-${host_arch}.tar.gz"
toolchain_url="https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-${toolchain_release}/${toolchain_archive}"

# shellcheck disable=SC2164
script_dir=$(cd -- "$(dirname "$0")" &>/dev/null; pwd -P)
toolchain_dir="${script_dir}/toolchain"

# create the toolchain directory
mkdir -p "${toolchain_dir}" && cd "${toolchain_dir}" || exit 1

# download the toolchain
if [ ! -f "${toolchain_archive}" ]; then
    echo "Downloading toolchain..."
    curl -JLO "${toolchain_url}"
else
    echo "Toolchain already downloaded."
fi

# extract the toolchain
echo "Extracting toolchain..."
tar -C "${toolchain_dir}" -xaf "${toolchain_archive}"

# append the toolchain to the PATH, if not already present
if ! echo "${PATH}" | grep -q "${toolchain_dir}/bin"; then
    echo "Appending toolchain to PATH..."
    export PATH="${toolchain_dir}/bin:${PATH}"
else
    echo "Toolchain already in PATH."
fi

# delete the archive
if [ -f "${toolchain_archive}" ]; then
    echo "Deleting archive..."
    rm -f "${toolchain_archive}"
fi

echo "Done!"
exit 0
