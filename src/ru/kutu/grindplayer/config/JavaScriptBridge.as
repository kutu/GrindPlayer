package ru.kutu.grindplayer.config {
	
	import flash.external.ExternalInterface;
	import flash.net.NetStream;
	
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MetadataEvent;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.LoadState;
	import org.osmf.net.NetStreamLoadTrait;
	
	import ru.kutu.grind.config.JavaScriptBridgeBase;
	import ru.kutu.grind.events.MediaElementChangeEvent;
	import ru.kutu.osmf.subtitles.SubtitlesEvent;
	
	import robotlegs.bender.framework.api.ILogger;
	
	public class JavaScriptBridge extends JavaScriptBridgeBase {
		
		[Inject] public var logger:ILogger;
		
		private var netStream:NetStream = null;
		
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
		
		[PostConstruct]
		override public function init():void {
			super.init();
			
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerStateChangeForBufferTimeAdjustment);
			player.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChangeToGetNetStream);
			player.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onCurrentTimeChangeForBufferTimeAdjustment);
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
		
		private function onPlayerStateChangeForBufferTimeAdjustment(e:MediaPlayerStateChangeEvent):void
		{
			if (e.state == MediaPlayerState.PAUSED)
			{
				if ( netStream != null ) {
					if (netStream.bufferTime != player.bufferTime) {
						CONFIG::LOGGING {
							logger.info("NetStream BufferTime: " + netStream.bufferTime);
						}
						
						netStream.bufferTime = player.bufferTime;
					}
					CONFIG::LOGGING {
						logger.info("Player State: " + player.state + "," + player.bufferTime + "," + netStream.bufferTime);
					}
				}
			}
		}
		
		private function onLoadStateChangeToGetNetStream(e:LoadEvent):void {
			if (e.loadState == LoadState.READY) {
				var nsLoadTrait:NetStreamLoadTrait = player.media.getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
				netStream = nsLoadTrait.netStream;
			}
		}
		
		private function onCurrentTimeChangeForBufferTimeAdjustment(event:TimeEvent):void {
			if ( netStream != null ) {
				if (player.state != MediaPlayerState.BUFFERING) {
					netStream.bufferTime = player.bufferTime;
				} else {
					netStream.bufferTime = 2;
				}
			}
		}
	}
	
}
