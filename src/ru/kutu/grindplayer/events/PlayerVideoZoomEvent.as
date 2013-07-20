package ru.kutu.grindplayer.events {

	import flash.events.Event;

	public class PlayerVideoZoomEvent extends Event {

		public static const ZOOM_IN:String = "playerVideoZoom.in";
		public static const ZOOM_OUT:String = "playerVideoZoom.out";
		public static const ZOOM_RESET:String = "playerVideoZoom.reset";

		public function PlayerVideoZoomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone():Event {
			return new PlayerVideoZoomEvent(type, bubbles, cancelable);
		}

		override public function toString():String {
			return formatToString("PlayerVideoZoomEvent", "type", "bubbles", "cancelable", "eventPhase");
		}

	}

}
