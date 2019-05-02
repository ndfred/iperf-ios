#!/bin/sh -ex

cd "`dirname \"$0\"`"

# FFFFFF-1.0.png is from http://www.1x1px.me/FFFFFF-1.0.png
sips -s format png --padToHeightWidth 120 120 --padColor FFFFFF FFFFFF-1.0.png --out Assets.xcassets/AppIcon.appiconset/Icon-120.png
sips -s format png --padToHeightWidth 152 152 --padColor FFFFFF FFFFFF-1.0.png --out Assets.xcassets/AppIcon.appiconset/Icon-152.png
sips -s format png --padToHeightWidth 167 167 --padColor FFFFFF FFFFFF-1.0.png --out Assets.xcassets/AppIcon.appiconset/Icon-167.png
