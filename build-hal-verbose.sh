#!/bin/bash
set -e  # Exit on error

echo "======================================"
echo "🚀 Halium Build Script Started"
echo "======================================"
date
echo ""

# Load environment
echo "📋 Loading environment variables..."
source halium.env
echo "   Device: $DEVICE"
echo "   Android Root: $ANDROID_ROOT"
echo ""

# Change to Android root
echo "📂 Changing to Android root directory..."
cd $ANDROID_ROOT
echo "   Current directory: $(pwd)"
echo ""

# Setup build environment
echo "🔧 Setting up build environment..."
source build/envsetup.sh
echo "   Build environment loaded ✓"
echo ""

# Apply patches
echo "🩹 Applying Hybris patches..."
if [ -f "hybris-patches/apply-patches.sh" ]; then
    bash hybris-patches/apply-patches.sh --mb
    echo "   Patches applied ✓"
else
    echo "   ⚠️  No patches found, skipping..."
fi
echo ""

# Enable ccache
echo "💾 Enabling ccache..."
export USE_CCACHE=1
echo "   ccache enabled ✓"
echo ""

# Run breakfast
echo "🍳 Running breakfast for $DEVICE..."
breakfast $DEVICE
echo "   Breakfast completed ✓"
echo ""

# Build mkbootimg
echo "🔨 Building mkbootimg..."
echo "   Start time: $(date +%H:%M:%S)"
make -j$(nproc) mkbootimg
echo "   mkbootimg built ✓"
echo ""

# Build fec
echo "🔨 Building fec..."
echo "   Start time: $(date +%H:%M:%S)"
make -j$(nproc) fec
echo "   fec built ✓"
echo ""

# Build halium-boot
echo "🔨 Building halium-boot image..."
echo "   Start time: $(date +%H:%M:%S)"
echo "   Using $(nproc) CPU cores"
make -j$(nproc) halium-boot
echo "   halium-boot.img built ✓"
echo ""

# Build system image
echo "🔨 Building system image..."
echo "   Start time: $(date +%H:%M:%S)"
echo "   ⚠️  This may take 30-60 minutes..."
make -j$(nproc) systemimage
echo "   system.img built ✓"
echo ""

# Build vendor image
echo "🔨 Building vendor image..."
echo "   Start time: $(date +%H:%M:%S)"
make -j$(nproc) vendorimage
echo "   vendor.img built ✓"
echo ""

# Calculate checksums
echo "======================================"
echo "📊 Build Summary"
echo "======================================"
echo "Build completed at: $(date)"
echo ""
echo "Generated Images:"
echo "├── halium-boot.img"
echo "├── system.img"
echo "└── vendor.img"
echo ""
echo "MD5 Checksums:"
echo "======================================"

if [ -f "$ANDROID_ROOT/out/target/product/$DEVICE/halium-boot.img" ]; then
    echo "halium-boot.img:"
    md5sum $ANDROID_ROOT/out/target/product/$DEVICE/halium-boot.img | awk '{print "  " $1}'
else
    echo "⚠️  halium-boot.img not found!"
fi

if [ -f "$ANDROID_ROOT/out/target/product/$DEVICE/system.img" ]; then
    echo "system.img:"
    md5sum $ANDROID_ROOT/out/target/product/$DEVICE/system.img | awk '{print "  " $1}'
else
    echo "⚠️  system.img not found!"
fi

if [ -f "$ANDROID_ROOT/out/target/product/$DEVICE/vendor.img" ]; then
    echo "vendor.img:"
    md5sum $ANDROID_ROOT/out/target/product/$DEVICE/vendor.img | awk '{print "  " $1}'
else
    echo "⚠️  vendor.img not found!"
fi

echo "======================================"
echo "✅ All builds completed successfully!"
echo "======================================"
