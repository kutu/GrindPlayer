package ru.kutu.grindplayer.views.mediators {
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.net.StreamType;
	
	import ru.kutu.grind.views.mediators.ScrubBarBaseMediator;
	
	public class ScrubBarMediator extends ScrubBarBaseMediator {
		
		private var isAdvertisement:Boolean;
		private var hideScrubBarWhileAdvertisement:Boolean;
		
		override protected function processMediaElementChange(oldMediaElement:MediaElement):void {
			super.processMediaElementChange(oldMediaElement);
			if (oldMediaElement) {
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_ADD, onMediaMetadataChange);
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_CHANGE, onMediaMetadataChange);
				oldMediaElement.metadata.removeEventListener(MetadataEvent.VALUE_REMOVE, onMediaMetadataChange);
			}
			if (media) {
				media.metadata.addEventListener(MetadataEvent.VALUE_ADD, onMediaMetadataChange);
				media.metadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMediaMetadataChange);
				media.metadata.addEventListener(MetadataEvent.VALUE_REMOVE, onMediaMetadataChange);
			}
		}
		
		override protected function updateEnabled():void {
			view.enabled = isStartPlaying && !isAdvertisement;
			view.visible = streamType != StreamType.LIVE && !hideScrubBarWhileAdvertisement;
		}
		
		private function onMediaMetadataChange(event:MetadataEvent):void {
			if (event.key != "Advertisement") return;
			isAdvertisement = event.type != MetadataEvent.VALUE_REMOVE;
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
