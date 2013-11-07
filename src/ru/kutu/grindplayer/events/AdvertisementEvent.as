package ru.kutu.grindplayer.events {

	import flash.events.Event;

	public class AdvertisementEvent extends Event {

		public static const ADVERTISEMENT:String = "advertisement";

		private var _isAdvertisement:Boolean;
		private var _ads:*;

		public function AdvertisementEvent(type:String, isAdvertisement:Boolean, ads:*, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_isAdvertisement = isAdvertisement;
			_ads = ads;
		}

		public function get isAdvertisement():Boolean { return _isAdvertisement }
		public function get ads():* { return _ads }

		override public function clone():Event {
			return new AdvertisementEvent(type, _isAdvertisement, ads, bubbles, cancelable);
		}

		override public function toString():String {
			return formatToString("AdvertisementEvent", "type", "isAdvertisement", "ads", "bubbles", "cancelable", "eventPhase");
		}

	}

}
