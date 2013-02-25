@if not defined flex_sdk (
	@call properties.bat
)

@call "%flex_bin%\compc.bat" -o "%build_dir%\libs\GrindFramework.swc" ^
	-debug=%debug% ^
	-swf-version=11 ^
	-target-player=10.2 ^
	-sp "%grind_framework%\src" ^
	-is "%grind_framework%\src" ^
	-external-library-path+=libs ^
	-define CONFIG::LOGGING %logging% ^
	-define CONFIG::FLASH_10_1 true
