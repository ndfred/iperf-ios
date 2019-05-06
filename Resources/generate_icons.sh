#!/bin/sh -ex

cd "`dirname \"$0\"`"

PREFIX="Assets.xcassets/AppIcon.appiconset"

rm -f "$PREFIX/Icon-"*.png

for i in 76 120 152 167 1024
do
  # FFFFFF-1.0.png is from http://www.1x1px.me/FFFFFF-1.0.png
  sips -s format png --padToHeightWidth $i $i --padColor FFFFFF FFFFFF-1.0.png --out "$PREFIX/Icon-$i.png"
done

mv "$PREFIX/Icon-76.png" "$PREFIX/Icon-77.png"
