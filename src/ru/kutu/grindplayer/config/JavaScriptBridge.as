package ru.kutu.grindplayer.config {
	
	import flash.external.ExternalInterface;
	
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MetadataEvent;
	
	import ru.kutu.grind.config.JavaScriptBridgeBase;
	import ru.kutu.grind.events.MediaElementChangeEvent;
	import ru.kutu.grindplayer.events.AdvertisementEvent;
	import ru.kutu.osmf.subtitles.SubtitlesEvent;
	
	public class JavaScriptBridge extends JavaScriptBridgeBase {
		
		public function JavaScriptBridge() {
			declaredByWhiteList.push("ru.kutu.grindplayer.media::GrindMediaPlayer");
		}
		
		[PostConstruct]
		override public function init():void {
			super.init();
			eventMap.mapListener(eventDispatcher, AdvertisementEvent.ADVERTISEMENT, onAdvertisement, AdvertisementEvent);
		}
		
		override protected function initializeEventMap():void {
			super.initializeEventMap();
			eventMaps[SubtitlesEvent.SUBTITLES_SWITCHING_CHANGE]	= function(event:SubtitlesEvent):Array{return [event.switching];};
			eventMaps[SubtitlesEvent.NUM_SUBTITLES_STREAMS_CHANGE]	= function(event:SubtitlesEvent):Array{return [];};
			eventMaps[SubtitlesEvent.HAS_SUBTITLES_CHANGE]			= function(event:MediaPlayerCapabilityChangeEvent):Array{return [event.enabled];};
		}
		
		private function onAdvertisement(event:AdvertisementEvent):void {
			var ids:Array = [];
			if (event.ads && event.ads is Array) {
				for each (var item:Object in event.ads) {
					ids.push(item.id);
				}
			}
			call([javascriptCallbackFunction, ExternalInterface.objectID, "advertisement", ids]);
		}
		
	}
	
}
