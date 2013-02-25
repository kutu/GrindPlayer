package ru.kutu.grindplayer.views.mediators {
	
	import flash.events.TimerEvent;
	
	import org.osmf.events.BufferEvent;
	import org.osmf.events.MetadataEvent;
	import org.osmf.media.MediaElement;
	
	import ru.kutu.grind.views.mediators.BufferInfoBaseMediator;
	
	public class BufferInfoMediator extends BufferInfoBaseMediator {
		
		private var isAdvertisement:Boolean;
		
		public function BufferInfoMediator() {
			super();
		}
		
		override protected function processMediaElementChange(oldMediaElement:MediaElement):void {
			if (oldMediaElement) {
				oldMediaElement.metadata.addEventListener(MetadataEvent.VALUE_ADD, onMetadataValue);
				oldMediaElement.metadata.addEventListener(MetadataEvent.VALUE_REMOVE, onMetadataValue);
			}
			if (media) {
				media.metadata.addEventListener(MetadataEvent.VALUE_ADD, onMetadataValue);
				media.metadata.addEventListener(MetadataEvent.VALUE_REMOVE, onMetadataValue);
			}
		}
		
		override protected function onBufferChangeTimer(event:TimerEvent):void {
			if (isAdvertisement) return;
			super.onBufferChangeTimer(event);
		}
		
		override protected function onBufferingChange(event:BufferEvent):void {
			if (isAdvertisement) return;
			super.onBufferingChange(event);
		}
		
		private function onMetadataValue(event:MetadataEvent):void {
			if (event.key != "Advertisement") return;
			isAdvertisement = event.type != MetadataEvent.VALUE_REMOVE;
			if (isAdvertisement) {
				view.data = null;
			}
		}
		
	}
	
}
