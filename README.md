# About

Grind Player — is a OSMF + Flex based flash video player, which provides most needed functionality in nowadays.

[Documentation &rarr;](http://osmfhls.kutu.ru/docs/grind/)

# Dependencies

- [Robotlegs Framework 2 &rarr;](http://www.robotlegs.org/)
- [Blooddy Crypto Library &rarr;](http://www.blooddy.by/crypto/)
- [Open Sans &rarr;](http://www.google.com/webfonts/specimen/Open+Sans) font

# Build

1. Install [Flex 4.13.0+ &rarr;](http://flex.apache.org/installer.html)
2. Download [playerglobal.swc 10.2 &rarr;](http://helpx.adobe.com/flash-player/kb/archived-flash-player-versions.html#playerglobal) and put it in
	`flex_sdk\frameworks\libs\player\10.2\playerglobal.swc`

3. `mkdir grind_player && cd grind_player`
4. Clone [Advertisement Plugin &rarr;](https://github.com/kutu/AdvertisementPlugin)
	`git clone git://github.com/kutu/AdvertisementPlugin.git`

5. Clone [Subtitles Plugin &rarr;](https://github.com/kutu/SubtitlesPlugin)
	`git clone git://github.com/kutu/SubtitlesPlugin.git`

6. Clone [Grind Framework &rarr;](https://github.com/kutu/GrindFramework)
	`git clone git://github.com/kutu/GrindFramework.git`

7. Clone [Grind Player &rarr;](https://github.com/kutu/GrindPlayer)
	`git clone git://github.com/kutu/GrindPlayer.git`

8. `cd GrindPlayer && copy properties.bat.tmpl properties.bat`
9. in `properties.bat` change `flex_sdk`
10. `release.bat`
