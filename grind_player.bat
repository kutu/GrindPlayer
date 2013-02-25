@if not defined flex_sdk (
	@call properties.bat
)

@call "%flex_bin%\mxmlc.bat" -o "%build_dir%\GrindPlayer.swf" ^
	-debug=%debug% ^
	-locale=en_US,ru_RU ^
	-swf-version=11 ^
	-target-player=10.2 ^
	-default-size=640,360 ^
	-default-background-color=0 ^
	-sp src locale\{locale} ^
	-l "%flex_sdk%\frameworks\libs" "%flex_sdk%\frameworks\locale\{locale}" ^
	-l libs "%build_dir%\libs" ^
	-externs ru.kutu.osmf.advertisement.AdvertisementPlugin ^
	-externs ru.kutu.osmf.subtitles.SubtitlesPlugin ^
	-define CONFIG::LOGGING %logging% ^
	-define CONFIG::HLS false ^
	-define CONFIG::DEV false ^
	%* ^
	src\GrindPlayer.mxml
