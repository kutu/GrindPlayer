package ru.kutu.grindplayer.views.mediators {
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.globalization.LocaleID;
	
	import mx.core.FlexGlobals;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfoResource;
	
	import ru.kutu.grind.views.mediators.PlayerViewBaseMediator;
	import ru.kutu.grindplayer.config.GrindPlayerConfiguration;
	import ru.kutu.grindplayer.events.AdvertisementEvent;
	import ru.kutu.grindplayer.events.PlayerVideoZoomEvent;
	import ru.kutu.osmf.advertisement.AdvertisementPluginInfo;
	import ru.kutu.osmf.subtitles.SubtitlesPluginInfo;
	
	CONFIG::HLS {
		import ru.kutu.osmf.hls.OSMFHLSPluginInfo;
	}
	
	public class PlayerViewMediator extends PlayerViewBaseMediator {
		
		private var _zoom:int;
		
		override public function initialize():void {
			super.initialize();
			addContextListener(AdvertisementEvent.ADVERTISEMENT, onAdvertisement, AdvertisementEvent);
		}
		
		override protected function processConfiguration(flashvars:Object):void {
			CONFIG::DEV {
				flashvars.src = "";
			}
			
			if ("locale" in flashvars) {
				var locale:String = flashvars.locale;
				var resourceManager:IResourceManager = ResourceManager.getInstance();
				var locales:Vector.<String> = Vector.<String>(resourceManager.localeChain);
				locales = LocaleID.determinePreferredLocales(new <String>[locale], locales);
				if (locales && locales.length) {
					locale = locales[0];
				}
				if (locale && locale.length) {
					var localeChain:Array = resourceManager.localeChain;
					var localeIndex:int = localeChain.indexOf(locale);
					if (localeIndex != -1) {
						localeChain.splice(localeIndex, 1);
						localeChain.unshift(locale);
						resourceManager.localeChain = localeChain;
					}
				}
			}
			
			super.processConfiguration(flashvars);
		}
		
		override protected function onConfigurationReady(event:Event):void {
			super.onConfigurationReady(event);
			
			contextView.view.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			onFullScreen();
			
			var gc:GrindPlayerConfiguration = configuration as GrindPlayerConfiguration;
			if (gc && !isNaN(gc.tintColor)) {
				FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("global").setStyle("tintColor", gc.tintColor);
			}
		}
		
		override protected function addCustomPlugins(pluginConfigurations:Vector.<MediaResourceBase>):void {
			pluginConfigurations.push(new PluginInfoResource(new SubtitlesPluginInfo()));
			pluginConfigurations.push(new PluginInfoResource(new AdvertisementPluginInfo()));
			CONFIG::HLS {
				pluginConfigurations.push(new PluginInfoResource(new OSMFHLSPluginInfo(contextView.view.loaderInfo)));
			}
		}
		
		override protected function initializeView():void {
			super.initializeView();
			
			addContextListener(PlayerVideoZoomEvent.ZOOM_IN, onZoom, PlayerVideoZoomEvent);
			addContextListener(PlayerVideoZoomEvent.ZOOM_OUT, onZoom, PlayerVideoZoomEvent);
			addContextListener(PlayerVideoZoomEvent.ZOOM_RESET, onZoom, PlayerVideoZoomEvent);
		}
		
		override protected function onViewResize(event:Event = null):void {
			if (mediaContainer) {
				const w:Number = view.mediaPlayerContainer.width;
				const h:Number = view.mediaPlayerContainer.height;
				videoContainer.width = w * (100 + _zoom) / 100;
				videoContainer.height = h * (100 + _zoom) / 100;
				videoContainer.validateNow();
				videoContainer.x = (w - videoContainer.width) / 2;
				videoContainer.y = (h - videoContainer.height) / 2;
				mediaContainer.width = w;
				mediaContainer.height = h;
				hitArea.graphics.clear();
				hitArea.graphics.beginFill(0);
				hitArea.graphics.drawRect(0, 0, w, h);
			}
		}
		
		private function get zoom():int { return _zoom }
		private function set zoom(value:int):void {
			if (value < -90) value = -90;
			if (value == _zoom) return;
			_zoom = value;
			onViewResize();
		}
		
		private function onZoom(event:PlayerVideoZoomEvent):void {
			switch (event.type) {
				case PlayerVideoZoomEvent.ZOOM_IN:    zoom++;   break;
				case PlayerVideoZoomEvent.ZOOM_OUT:   zoom--;   break;
				case PlayerVideoZoomEvent.ZOOM_RESET: zoom = 0; break;
			}
		}
		
		private function onFullScreen(event:FullScreenEvent = null):void {
			view.controlBarAutoHide = contextView.view.stage.displayState == StageDisplayState.NORMAL
				? configuration.controlBarAutoHide
				: configuration.controlBarFullScreenAutoHide;
		}
		
		private function onAdvertisement(event:AdvertisementEvent):void {
			// check at least one ad has layoutInfo and isAdvertisement
			var isAdvertisement:Boolean;
			if (event.ads && event.ads is Array) {
				for each (var item:Object in event.ads) {
					if ("layoutInfo" in item && !item.layoutInfo && "isAdvertisement" in item && item.isAdvertisement) {
						isAdvertisement = true;
						break;
					}
				}
			}
			
			// remove main media from videoContainer if ad is linear
			if (isAdvertisement && videoContainer.containsMediaElement(player.media)) {
				videoContainer.removeMediaElement(player.media);
			} else if (!isAdvertisement && !videoContainer.containsMediaElement(player.media)) {
				videoContainer.addMediaElement(player.media);
			}
		}
		
	}
	
}
