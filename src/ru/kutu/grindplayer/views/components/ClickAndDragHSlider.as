package ru.kutu.grindplayer.views.components {
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.HSlider;
	
	public class ClickAndDragHSlider extends HSlider {
		
		public function ClickAndDragHSlider() {
			super();
		}
		
		override protected function track_mouseDownHandler(event:MouseEvent):void {
			dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
			super.track_mouseDownHandler(event);
			validateNow();
			super.thumb_mouseDownHandler(event);
		}
		
	}
	
}
