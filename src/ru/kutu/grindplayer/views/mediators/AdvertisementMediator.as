package ru.kutu.grindplayer.views.mediators {
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.media.MediaElement;
	
	import ru.kutu.grind.views.mediators.MediaControlBaseMediator;
	import ru.kutu.grindplayer.events.AdvertisementEvent;
	
	public class AdvertisementMediator extends MediaControlBaseMediator {
		
		private var isAdvertisement:Boolean;
		
		override protected function processMediaElementChange(oldMediaElement:MediaElement):void {
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
		
		private function onMetadataChange(event:MetadataEvent):void {
			if (event.key != "Advertisement") return;
			isAdvertisement = event.type != MetadataEvent.VALUE_REMOVE;
			if (isAdvertisement && event.value && event.value is Array && event.value.length) {
				isAdvertisement = false;
				for each (var item:Object in event.value) {
					if ("isAdvertisement" in item) {
						isAdvertisement ||= item.isAdvertisement;
						if (isAdvertisement) break;
					}
				}
			}
			dispatch(new AdvertisementEvent(AdvertisementEvent.ADVERTISEMENT, isAdvertisement, event.value));
		}
		
	}
	
}
