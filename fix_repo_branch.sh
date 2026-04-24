for file in .github/workflows/build.yml build.yml .github/workflows/main.yml main.yml; do
    sed -i 's/<project path="kernel\/xiaomi\/clover" name="ubuntu-touch-clover\/halium_kernel_xiaomi_clover" remote="github" revision="master" \/>/<project path="kernel\/xiaomi\/clover" name="ubuntu-touch-clover\/halium_kernel_xiaomi_clover" remote="github" revision="halium-9.0" \/>/g' $file
done
