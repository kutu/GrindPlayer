package ru.kutu.grindplayer.views.components {
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import spark.core.SpriteVisualElement;
	
	public class Subtitles extends SpriteVisualElement {
		
		public var label:SubtitlesText;
		
		private var updatePending:Boolean;
		private var lastWidth:Number;
		
		private var fontSize:Number;
		private var minFontSize:int;
		private var maxFontSize:int;
		
		public function Subtitles() {
			super();
			mouseEnabled = mouseChildren = false;
			setConfig({});
			label = new SubtitlesText();
			addChild(label);
		}
		
		public function update():void {
			lastWidth = NaN;
			processUpdate();
		}
		
		public function setConfig(config:Object):void {
			fontSize = config.fontSize || 0.035;
			minFontSize = config.minFontSize || 14;
			maxFontSize = config.maxFontSize || 36;
			if ("textColor" in config) label.textColor = config.textColor;
			if ("bgColor" in config) label.bgColor = config.bgColor;
			if ("bgAlpha" in config) label.bgAlpha = config.bgAlpha;
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
			
			label.fontSize = Math.min(maxFontSize, Math.max(minFontSize, width * fontSize | 0));
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
