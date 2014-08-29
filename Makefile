FLEX_SDK ?= /usr/local/flex_sdk_4
MXMLC ?= $(FLEX_SDK)/bin/mxmlc
COMPC ?= $(FLEX_SDK)/bin/compc
BUILD_DIR ?= build
GRIND_PLAYER=$(BUILD_DIR)/GrindPlayer.swf
GRIND_FRAMEWORK=$(BUILD_DIR)/libs/GrindFramework.swc
ADVERTISEMENT_PLUGIN=$(BUILD_DIR)/libs/AdvertisementPlugin.swc
SUBTITLES_PLUGIN=$(BUILD_DIR)/libs/SubtitlesPlugin.swc

DEBUG ?= false
LOGGING ?= false

TARGET_PLAYER ?= 10.2

SRC = src/GrindPlayer.mxml

all: $(GRIND_PLAYER)


clean:
	rm -rf build


$(BUILD_DIR): $(BUILD_DIR)/libs
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/libs:
	mkdir -p $(BUILD_DIR)/libs
	cp libs/* $(BUILD_DIR)/libs/




$(GRIND_PLAYER): $(BUILD_DIR) $(GRIND_FRAMEWORK) $(ADVERTISEMENT_PLUGIN) $(SUBTITLES_PLUGIN) $(SRC)
	$(MXMLC) -o $(GRIND_PLAYER) \
	-debug=$(DEBUG) \
	-locale=en_US,ru_RU \
	-swf-version=11 \
	-target-player=$(TARGET_PLAYER) \
	-default-size=640,360 \
	-default-background-color=0 \
	-sp src locale/{locale} \
	-l "$(FLEX_SDK)/frameworks/libs" "$(FLEX_SDK)/frameworks/locale/{locale}" \
	-l libs "$(BUILD_DIR)/libs" \
	-externs ru.kutu.osmf.advertisement.AdvertisementPlugin \
	-externs ru.kutu.osmf.subtitles.SubtitlesPlugin \
	-define CONFIG::HLS false \
	-define CONFIG::DEV false \
	src/GrindPlayer.mxml \


GrindFramework:
	git clone git://github.com/geeee/GrindFramework --depth 1


$(GRIND_FRAMEWORK): GrindFramework
	$(COMPC) -o $(GRIND_FRAMEWORK) \
	-debug=$(DEBUG) \
	-swf-version=11 \
	-target-player=$(TARGET_PLAYER) \
	-sp "GrindFramework/src" \
	-is "GrindFramework/src" \
	-external-library-path+="$(FLEX_SDK)/frameworks/libs",libs \
	-define CONFIG::LOGGING $(LOGGING) \
	-define CONFIG::FLASH_10_1 true


AdvertisementPlugin:
	git clone git://github.com/kutu/AdvertisementPlugin --depth 1

$(ADVERTISEMENT_PLUGIN): AdvertisementPlugin
	$(COMPC) -o $(ADVERTISEMENT_PLUGIN) \
	-debug=$(DEBUG) \
	-swf-version=11 \
	-target-player=$(TARGET_PLAYER) \
	-sp "AdvertisementPlugin/src" \
	-is "AdvertisementPlugin/src" \
	-external-library-path+="$(FLEX_SDK)/frameworks/libs" \
	-define CONFIG::LOGGING $(LOGGING)

SubtitlesPlugin:
	git clone git://github.com/kutu/SubtitlesPlugin --depth 1

$(SUBTITLES_PLUGIN): SubtitlesPlugin
	$(COMPC) -o $(SUBTITLES_PLUGIN) \
	-debug=$(DEBUG) \
	-swf-version=11 \
	-target-player=$(TARGET_PLAYER) \
	-sp "SubtitlesPlugin/src" \
	-is "SubtitlesPlugin/src" \
	-external-library-path+="$(FLEX_SDK)/frameworks/libs",libs \
	-define CONFIG::LOGGING $(LOGGING)

