@if not defined flex_sdk (
	@call properties.bat
)

@call "%flex_bin%\compc.bat" -o "%build_dir%\libs\AdvertisementPlugin.swc" ^
	-debug=%debug% ^
	-swf-version=11 ^
	-target-player=10.2 ^
	-sp "%advertisement_plugin%\src" ^
	-is "%advertisement_plugin%\src" ^
	-external-library-path+="%flex_sdk%\frameworks\libs" ^
	-define CONFIG::LOGGING %logging%
