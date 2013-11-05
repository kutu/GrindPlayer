package ru.kutu.grindplayer.views.mediators {
	
	import ru.kutu.grind.views.mediators.AutoHideBaseMediator;
	import ru.kutu.grindplayer.events.AdvertisementEvent;
	
	public class AutoHideMediator extends AutoHideBaseMediator {
		
		private var isAdvertisement:Boolean;
		
		override public function initialize():void {
			super.initialize();
			addContextListener(AdvertisementEvent.ADVERTISEMENT, onAdvertisement, AdvertisementEvent);
		}
		
		override protected function checkVisibility():void {
			visible =
				isReady
				&&
				(
					(!isPlaying && !isAdvertisement)
					||
					hasWaitTarget
					||
					(!isFullScreen && !isMouseLeave && !isAutoHideComplete)
					||
					(isFullScreen && isMouseMove && !isAutoHideComplete)
				);
			
			if (_visible) {
				resetAutoHideTimer();
			}
		}
		
		private function onAdvertisement(event:AdvertisementEvent):void {
			isAdvertisement = event.isAdvertisement;
			checkVisibility();
		}
		
	}
	
}
