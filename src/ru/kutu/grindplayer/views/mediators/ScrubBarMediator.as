package ru.kutu.grindplayer.views.mediators {
	
	import org.osmf.net.StreamType;
	
	import ru.kutu.grind.views.mediators.ScrubBarBaseMediator;
	import ru.kutu.grindplayer.events.AdvertisementEvent;
	
	public class ScrubBarMediator extends ScrubBarBaseMediator {
		
		private var hideScrubBarWhileAdvertisement:Boolean;
		
		override public function initialize():void {
			super.initialize();
			addContextListener(AdvertisementEvent.ADVERTISEMENT, onAdvertisement, AdvertisementEvent);
		}
		
		override protected function updateEnabled():void {
			view.enabled = isStartPlaying;
			view.visible = streamType != StreamType.LIVE && !hideScrubBarWhileAdvertisement;
		}
		
		private function onAdvertisement(event:AdvertisementEvent):void {
			hideScrubBarWhileAdvertisement = false;
			if (event.ads && event.ads is Array) {
				for each (var item:Object in event.ads) {
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
