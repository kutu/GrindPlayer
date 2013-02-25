package ru.kutu.grindplayer.views.components {
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import spark.core.SpriteVisualElement;
	
	public class Subtitles extends SpriteVisualElement {
		
		public var label:SubtitlesText;
		
		private var updatePending:Boolean;
		private var lastWidth:Number;
		
		public function Subtitles() {
			super();
			mouseEnabled = mouseChildren = false;
			label = new SubtitlesText();
			addChild(label);
		}
		
		public function update():void {
			lastWidth = NaN;
			processUpdate();
		}
		
		override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean=true):void {
			startPendingUpdate();
			super.setLayoutBoundsSize(width, height, postLayoutTransform);
		}
		
		private function startPendingUpdate():void {
			if (!visible || updatePending) return;
			updatePending = true;
			addEventListener(Event.ENTER_FRAME, onNextFrame);
		}
		
		private function onNextFrame(event:Event):void {
			updatePending = false;
			removeEventListener(Event.ENTER_FRAME, onNextFrame);
			processUpdate();
		}
		
		private function processUpdate():void {
			if (lastWidth == width) return;
			lastWidth = width;
			
			label.fontSize = Math.max(14, width / 50 | 0);
			label.width = width;
			label.update();
			var rect:Rectangle = label.getBounds(this);
			if (rect.width == 0 || rect.height == 0) {
				lastWidth = NaN;
				return;
			}
			viewWidth = 2*rect.x + rect.width;
			viewHeight = rect.y + rect.height;
			invalidateParentSizeAndDisplayList();
		}
		
	}
	
}
