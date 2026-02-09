#!/bin/bash
# Device configuration script
# Usage: ./setup-device.sh <device-name> [android-root-path]

set -e

DEVICE_NAME=${1:-clover}
ANDROID_ROOT_PATH=${2:-/home/runner/work/halium}

echo "=== Setting up device configuration ==="
echo "Device: $DEVICE_NAME"
echo "Android Root: $ANDROID_ROOT_PATH"

# Create halium.env file
cat > halium.env << EOF
export DEVICE="$DEVICE_NAME"
export ANDROID_ROOT=$ANDROID_ROOT_PATH
export PATH=\$PATH:~/bin/
alias python=python3
EOF

echo "halium.env created successfully"

# Update GitHub Actions workflow if needed
if [ -f ".github/workflows/build.yml" ]; then
    echo "Updating workflow file..."
    # Backup original file
    cp .github/workflows/build.yml .github/workflows/build.yml.bak
    
    # Update DEVICE and VENDOR in workflow
    # This is a simple example, you might need more sophisticated updates
    echo "Please manually check .github/workflows/build.yml for device-specific settings"
fi

echo "=== Configuration complete ==="
echo ""
echo "Current configuration:"
cat halium.env
