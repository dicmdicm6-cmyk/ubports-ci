for file in .github/workflows/build.yml build.yml .github/workflows/main.yml main.yml; do
    sed -i 's/<project path="vendor\/xiaomi\/clover" name="TheMuppets\/proprietary_vendor_xiaomi" remote="github" revision="lineage-18.1" \/>/<project path="vendor\/xiaomi\/clover" name="TheMuppets\/proprietary_vendor_xiaomi" remote="github" revision="lineage-18.1" \/>/g' $file
done
