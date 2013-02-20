#!/bin/bash
rm icons.iconset/*.png

convert icon.png -resize 16x16 icons.iconset/icon_16x16.png
convert icon.png -resize 32x32 icons.iconset/icon_16x16@2x.png

convert icon.png -resize 32x32 icons.iconset/icon_32x32.png
convert icon.png -resize 64x64 icons.iconset/icon_32x32@2x.png

convert icon.png -resize 128x128 icons.iconset/icon_128x128.png
convert icon.png -resize 256x256 icons.iconset/icon_128x128@2x.png

convert icon.png -resize 256x256 icons.iconset/icon_256x256.png
convert icon.png -resize 512x512 icons.iconset/icon_256x256@2x.png

convert icon.png -resize 512x512 icons.iconset/icon_512x512.png
convert icon.png -resize 1024x1024 icons.iconset/icon_512x512@2x.png

iconutil -c icns icons.iconset -o ../sexy-wallpaper/icons.icns
