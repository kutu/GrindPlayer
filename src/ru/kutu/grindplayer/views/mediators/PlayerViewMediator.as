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
	import ru.kutu.osmf.advertisement.AdvertisementPluginInfo;
	import ru.kutu.osmf.subtitles.SubtitlesPluginInfo;
	
	CONFIG::HLS {
		import ru.kutu.osmf.hls.OSMFHLSPluginInfo;
	}
	
	public class PlayerViewMediator extends PlayerViewBaseMediator {
		
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
		
		private function onFullScreen(event:FullScreenEvent = null):void {
			view.controlBarAutoHide = contextView.view.stage.displayState == StageDisplayState.NORMAL
				? configuration.controlBarAutoHide
				: configuration.controlBarFullScreenAutoHide;
		}
		
	}
	
}
