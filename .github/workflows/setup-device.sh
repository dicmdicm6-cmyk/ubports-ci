#!/bin/bash
# Halium Device Configuration Script (Updated for Ubuntu 24.04 & Halium 11)
# Usage: ./setup-device.sh <vendor> <device> [android-root-path]

set -e

# 인자 처리 및 도움말
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <vendor> <device> [android-root-path]"
    echo "Example: $0 xiaomi clover /home/runner/work/halium"
    exit 1
fi

VENDOR_NAME=$1
DEVICE_NAME=$2
ANDROID_ROOT_PATH=${3:-/home/runner/work/halium}

echo "======================================"
echo "🔧 Configuring Halium Build Environment"
echo "======================================"
echo "Vendor: $VENDOR_NAME"
echo "Device: $DEVICE_NAME"
echo "Root  : $ANDROID_ROOT_PATH"

# 1. halium.env 생성 (Python 2.7 경로 및 별칭 포함)
cat > halium.env << EOF
# Halium Build Environment Variables
export VENDOR="$VENDOR_NAME"
export DEVICE="$DEVICE_NAME"
export ANDROID_ROOT="$ANDROID_ROOT_PATH"
export PATH="\$PATH:~/bin"

# Ensure Python 2 is used for legacy build scripts
if [ -f /usr/bin/python2.7 ]; then
    alias python='/usr/bin/python2.7'
fi
EOF

echo "✅ halium.env created successfully."

# 2. 워크플로우 파일 자동 업데이트 (.yml)
# .github/workflows 폴더 내의 DEVICE: 및 VENDOR: 값을 실제 입력값으로 교체합니다.
WORKFLOW_DIR=".github/workflows"
if [ -d "$WORKFLOW_DIR" ]; then
    echo "🔄 Updating GitHub Actions workflow files..."
    
    find "$WORKFLOW_DIR" -name "*.yml" -exec sed -i "s/DEVICE: .*/DEVICE: $DEVICE_NAME/g" {} +
    find "$WORKFLOW_DIR" -name "*.yml" -exec sed -i "s/VENDOR: .*/VENDOR: $VENDOR_NAME/g" {} +
    
    echo "✅ Workflow files updated to $VENDOR_NAME/$DEVICE_NAME."
else
    echo "⚠️  Workflow directory not found. Skipping auto-patch."
fi

# 3. 환경 검증
echo "--------------------------------------"
echo "🔍 Validating Setup..."

if command -v python2.7 >/dev/null 2>&1; then
    echo "  - Python 2.7: Found"
else
    echo "  - Python 2.7: NOT FOUND (Run 'sudo apt install python2.7' if on local)"
fi

echo "======================================"
echo "✨ Configuration Complete!"
echo "Next step: git add . && git commit -m 'Update device to $DEVICE_NAME'"
echo "======================================"
