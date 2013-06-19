package ru.kutu.grindplayer.views.mediators {
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.net.StreamType;
	
	import ru.kutu.grind.views.mediators.ScrubBarBaseMediator;
	
	public class ScrubBarMediator extends ScrubBarBaseMediator {
		
		private var hideScrubBarWhileAdvertisement:Boolean;
		
		override protected function processMediaElementChange(oldMediaElement:MediaElement):void {
			super.processMediaElementChange(oldMediaElement);
			if (oldMediaElement) {
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_ADD, onMetadataChange);
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_CHANGE, onMetadataChange);
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_REMOVE, onMetadataChange);
			}
			if (media) {
				media.metadata.addEventListener(MetadataEvent.VALUE_ADD, onMetadataChange);
				media.metadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMetadataChange);
				media.metadata.addEventListener(MetadataEvent.VALUE_REMOVE, onMetadataChange);
			}
		}
		
		override protected function updateEnabled():void {
			view.enabled = isStartPlaying;
			view.visible = streamType != StreamType.LIVE && !hideScrubBarWhileAdvertisement;
		}
		
		private function onMetadataChange(event:MetadataEvent):void {
			if (event.key != "Advertisement") return;
			hideScrubBarWhileAdvertisement = false;
			if (event.value && event.value is Array) {
				for each (var item:Object in event.value) {
					if ("hideScrubBarWhilePlayingAd" in item && item.hideScrubBarWhilePlayingAd) {
						hideScrubBarWhileAdvertisement = true;
						break;
					}
				}
			}
			updateEnabled();
		}
		
	}
	
}
