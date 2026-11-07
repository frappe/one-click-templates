#!/bin/bash
# Install the runner for the runner user. 001_onboot registers it, because the registration token belongs to one VM.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

RUNNER_VERSION=2.338.2
RUNNER_ROOT=/opt/actions-runner

case "$(dpkg --print-architecture)" in
amd64) arch=x64 checksum=baebf204307bac6193480852732f0aba2ae97b6c5597c244f4d5558390147c40 ;;
arm64) arch=arm64 checksum=670adb2f268fe21dcbb58b3db0e0aa9d5b3bddfe2c651481336e561ff86de945 ;;
*)
	echo "The runner has no build for $(dpkg --print-architecture)." >&2
	exit 1
	;;
esac

# Workflows install tools with sudo, as on GitHub-hosted runners. The docker group grants root already.
useradd --create-home --shell /bin/bash --groups docker runner
printf 'runner ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/runner
chmod 0440 /etc/sudoers.d/runner
visudo -cf /etc/sudoers.d/runner

tarball=$(mktemp)
curl -fsSL -o "$tarball" \
	"https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${arch}-${RUNNER_VERSION}.tar.gz"
echo "$checksum  $tarball" | sha256sum -c -
install -d "$RUNNER_ROOT"
tar -xzf "$tarball" -C "$RUNNER_ROOT"
rm -f "$tarball"
# The runner's own svc.sh runs the service from this copy.
cp "$RUNNER_ROOT/bin/runsvc.sh" "$RUNNER_ROOT/runsvc.sh"
# The runner updates itself in place, so its user owns the folder.
chown -R runner:runner "$RUNNER_ROOT"

# The package started Docker, which made an engine ID that must differ on every VM. Docker makes a new one at first boot.
systemctl stop docker.service docker.socket
rm -f /var/lib/docker/engine-id
systemctl enable docker actions-runner
