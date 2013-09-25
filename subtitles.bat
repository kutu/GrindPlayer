@if not defined flex_sdk (
	@call properties.bat
)

@call "%flex_bin%\compc.bat" -o "%build_dir%\libs\SubtitlesPlugin.swc" ^
	-debug=%debug% ^
	-swf-version=11 ^
	-target-player=10.2 ^
	-sp "%subtitles_plugin%\src" ^
	-is "%subtitles_plugin%\src" ^
	-l libs\blooddy_crypto.swc ^
	-external-library-path+=libs\OSMF.swc ^
	-define CONFIG::LOGGING %logging%
