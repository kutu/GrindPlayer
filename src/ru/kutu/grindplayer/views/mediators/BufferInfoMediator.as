package ru.kutu.grindplayer.views.mediators {
	
	import flash.events.TimerEvent;
	
	import org.osmf.events.BufferEvent;
	
	import ru.kutu.grind.views.mediators.BufferInfoBaseMediator;
	import ru.kutu.grindplayer.events.AdvertisementEvent;
	
	public class BufferInfoMediator extends BufferInfoBaseMediator {
		
		private var isAdvertisement:Boolean;
		
		override public function initialize():void {
			super.initialize();
			addContextListener(AdvertisementEvent.ADVERTISEMENT, onAdvertisement, AdvertisementEvent);
		}
		
		override protected function onBufferChangeTimer(event:TimerEvent):void {
			if (isAdvertisement) return;
			super.onBufferChangeTimer(event);
		}
		
		override protected function onBufferingChange(event:BufferEvent):void {
			if (isAdvertisement) return;
			super.onBufferingChange(event);
		}
		
		private function onAdvertisement(event:AdvertisementEvent):void {
			isAdvertisement = event.isAdvertisement;
			if (isAdvertisement) {
				view.data = null;
			}
		}
		
	}
	
}
