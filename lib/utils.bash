#!/usr/bin/env bash

set -euo pipefail

TOOL_NAME="solana"
TOOL_TEST="solana --version"

# Default download root can be overridden by SOLANA_DOWNLOAD_ROOT env var
SOLANA_DOWNLOAD_ROOT="${SOLANA_DOWNLOAD_ROOT:-https://github.com/anza-xyz/agave/releases/download}"
GH_LATEST_RELEASE="https://api.github.com/repos/anza-xyz/agave/releases/latest"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

get_machine_arch() {
	local _ostype _cputype
	_ostype="$(uname -s)"
	_cputype="$(uname -m)"

	case "$_ostype" in
		Linux)
			_ostype=unknown-linux-gnu
			;;
		Darwin)
			if [[ $_cputype = arm64 ]]; then
				_cputype=aarch64
			fi
			_ostype=apple-darwin
			;;
		*)
			fail "machine architecture is currently unsupported"
			;;
	esac
	echo "${_cputype}-${_ostype}"
}

list_all_versions() {
	# Fetch the latest release version from GitHub API
	local release_file
	release_file="$(mktemp)"
	curl "${curl_opts[@]}" "$GH_LATEST_RELEASE" > "$release_file"

	local version
	version=$(grep -m 1 \"tag_name\": "$release_file" | sed -ne 's/^ *"tag_name": "\([^"]*\)",$/\1/p')
	rm -f "$release_file"

	if [ -z "$version" ]; then
		fail "Unable to determine latest version"
	fi

	echo "$version"
}

download_release() {
	local version="$1"
	local filename="$2"
	local arch
	arch="$(get_machine_arch)"

	# Add 'v' prefix if not present
	[[ "$version" = v* ]] || version="v${version}"

	# Construct download URL according to official installer format
	local download_url="${SOLANA_DOWNLOAD_ROOT}/${version}/agave-install-init-${arch}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" "$download_url" || fail "Could not download $download_url"
	chmod +x "$filename"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		local installer="$ASDF_DOWNLOAD_PATH/agave-install-init"

		# Run the installer
		"$installer" || fail "Installation failed"

		# Verify installation
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		if ! command -v "$tool_cmd" >/dev/null; then
			fail "Expected $tool_cmd to be available in PATH after installation."
		fi

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
