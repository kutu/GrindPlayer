package ru.kutu.grindplayer.config {
	
	import flash.external.ExternalInterface;
	
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MetadataEvent;
	
	import ru.kutu.grind.config.JavaScriptBridgeBase;
	import ru.kutu.grind.events.MediaElementChangeEvent;
	import ru.kutu.osmf.subtitles.SubtitlesEvent;
	
	public class JavaScriptBridge extends JavaScriptBridgeBase {
		
		public function JavaScriptBridge() {
			declaredByWhiteList.push("ru.kutu.grindplayer.media::GrindMediaPlayer");
		}
		
		override protected function onMediaElementChanged(event:MediaElementChangeEvent):void {
			if (media) {
				media.metadata.removeEventListener(MetadataEvent.VALUE_ADD, onMediaMetadataChange);
				media.metadata.removeEventListener(MetadataEvent.VALUE_CHANGE, onMediaMetadataChange);
				media.metadata.removeEventListener(MetadataEvent.VALUE_REMOVE, onMediaMetadataChange);
			}
			super.onMediaElementChanged(event);
			if (media) {
				media.metadata.addEventListener(MetadataEvent.VALUE_ADD, onMediaMetadataChange);
				media.metadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMediaMetadataChange);
				media.metadata.addEventListener(MetadataEvent.VALUE_REMOVE, onMediaMetadataChange);
			}
		}
		
		override protected function initializeEventMap():void {
			super.initializeEventMap();
			eventMaps[SubtitlesEvent.SUBTITLES_SWITCHING_CHANGE]	= function(event:SubtitlesEvent):Array{return [event.switching];};
			eventMaps[SubtitlesEvent.NUM_SUBTITLES_STREAMS_CHANGE]	= function(event:SubtitlesEvent):Array{return [];};
			eventMaps[SubtitlesEvent.HAS_SUBTITLES_CHANGE]			= function(event:MediaPlayerCapabilityChangeEvent):Array{return [event.enabled];};
		}
		
		private function onMediaMetadataChange(event:MetadataEvent):void {
			if (event.key == "Advertisement") {
				var ids:Array = [];
				if (event.value && event.value is Array) {
					for each (var item:Object in event.value) {
						ids.push(item.id);
					}
				}
				call([javascriptCallbackFunction, ExternalInterface.objectID, "advertisement", ids]);
			}
		}
		
	}
	
}
