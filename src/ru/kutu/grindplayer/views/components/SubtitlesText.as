package ru.kutu.grindplayer.views.components {
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.engine.FontLookup;
	
	import flashx.textLayout.factory.StringTextLineFactory;
	import flashx.textLayout.formats.BaselineOffset;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	public class SubtitlesText extends Sprite {
		
		private static const factory:StringTextLineFactory = new StringTextLineFactory();
		private static const rect:Rectangle = new Rectangle();
		
		private const textFormat:TextLayoutFormat = new TextLayoutFormat();
		private const compositionBounds:Rectangle = new Rectangle(0, 0, 0, 1000);
		
		private var backgroundPadding:Number;
		private var minY:Number;
		private var isDirty:Boolean = true;
		private var _text:String;
		
		public function SubtitlesText() {
			textFormat.color = 0xDFDFDF;
			textFormat.fontFamily = "Open Sans";
			textFormat.fontLookup = FontLookup.EMBEDDED_CFF;
			textFormat.textAlign = TextAlign.CENTER;
			textFormat.lineHeight = "150%";
			textFormat.firstBaselineOffset = BaselineOffset.LINE_HEIGHT;
		}
		
		public function set fontSize(value:Number):void {
			if (value == textFormat.fontSize) return;
			textFormat.fontSize = value;
			backgroundPadding = value * .5 / 2; // .5 is 150% lineHeight
			compositionBounds.y = backgroundPadding;
			factory.textFlowFormat = textFormat;
			isDirty = true;
		}
		
		public function set text(value:String):void {
			// filter tags
			value = value.replace(/<.*?>/g, "");
			
			if (value == _text) return;
			_text = value;
			isDirty = true;
		}
		
		override public function set width(value:Number):void {
			var newValue:Number = value - 2 * backgroundPadding;
			if (compositionBounds.width == newValue) return;
			compositionBounds.width = newValue;
			isDirty = true;
		}
		
		public function update():void {
			if (!isDirty) return;
			
			while (numChildren) removeChildAt(0);
			graphics.clear();
			
			if (_text && _text.length) {
				minY = NaN;
				factory.compositionBounds = compositionBounds;
				factory.text = _text;
				factory.createTextLines(onCreateTextLine);
			}
			
			isDirty = false;
		}
		
		private function onCreateTextLine(line:DisplayObject):void {
			addChild(line);
			createBackground(line.getBounds(this));
		}
		
		private function createBackground(r:Rectangle):void {
			var g:Graphics = graphics;
			var p:Number = backgroundPadding;
			
			rect.x = r.x - p | 0;
			rect.y = isNaN(minY) ? (r.y - p | 0) : minY;
			rect.width = Math.ceil(r.width + 2 * p + 1);
			rect.height = Math.ceil(r.height + 2 * p - (rect.y - (r.y - p | 0)));
			
			g.beginFill(0x101010, .8);
			g.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			minY = rect.y + rect.height;
		}
		
	}
	
}
