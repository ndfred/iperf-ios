ICONS_PATH := Assets.xcassets/AppIcon.appiconset

.PHONY: all clean

all: $(ICONS_PATH)/Icon-76.png $(ICONS_PATH)/Icon-120.png $(ICONS_PATH)/Icon-152.png $(ICONS_PATH)/Icon-167.png $(ICONS_PATH)/Icon-180.png $(ICONS_PATH)/Icon-1024.png

generator: IPFIconGenerator.m ../Source/UI/IPFIcon.m ../Source/UI/IPFIcon.h
	clang -pedantic -Wall -DIPF_ENABLE_FILE_WRITE=1 -I../Source/UI -framework Foundation -framework AppKit -framework Cocoa -framework QuartzCore IPFIconGenerator.m ../Source/UI/IPFIcon.m -o generator

$(ICONS_PATH)/Icon-76.png: generator
	./generator 76 $@

$(ICONS_PATH)/Icon-120.png: generator
	./generator 120 $@

$(ICONS_PATH)/Icon-152.png: generator
	./generator 152 $@

$(ICONS_PATH)/Icon-167.png: generator
	./generator 167 $@

$(ICONS_PATH)/Icon-180.png: generator
	./generator 180 $@

$(ICONS_PATH)/Icon-1024.png: generator
	./generator 1024 $@

clean:
	rm -f generator *.png
