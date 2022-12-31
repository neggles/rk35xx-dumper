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

# function to add toolchain to PATH, if not already in PATH
function add_toolchain_to_path() {
    # shellcheck disable=SC2164
    if ! (echo "${PATH}" | grep -qs "${toolchain_dir}/bin"); then
        echo "Toolchain not in PATH, adding..."
        export PATH="${toolchain_dir}/bin:${PATH}"
        echo "If that didn't work, run the following command:"
        echo "export PATH=\"${toolchain_dir}/bin:\${PATH}\""
    else
        echo "Toolchain is already in PATH."
    fi
}


# create the toolchain directory
mkdir -p "${toolchain_dir}" && cd "${toolchain_dir}" || exit 1

# check if toolchain is already installed
if [ -d "${toolchain_dir}/bin" ]; then
    echo "Toolchain already installed. Remove the toolchain directory to reinstall."
    echo -n "Checking if toolchain is in PATH... "
    add_toolchain_to_path
    exit 0
fi

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

# delete the archive
if [ -f "${toolchain_archive}" ]; then
    echo "Deleting archive..."
    rm -f "${toolchain_archive}"
fi

echo "Done!"
exit 0
