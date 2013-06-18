package ru.kutu.grindplayer.views.components.renderers {
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	
	import spark.core.SpriteVisualElement;
	
	public class StatBarChart extends SpriteVisualElement {
		
		protected static const BAR_COLOR:uint = 0x999999;
		protected static const BAR_NO_CHANGES_COLOR:uint = 0x666666;
		
		protected const values:Vector.<Number> = new Vector.<Number>();
		protected const chart:Shape = new Shape();
		
		protected var numValues:uint;
		
		protected var _max:Number = 0.0;
		protected var _barWidth:uint = 2;
		protected var _barGap:uint = 1;
		
		public function StatBarChart() {
			super();
			addChild(chart);
		}
		
		override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean=true):void {
			super.setLayoutBoundsSize(width, height, postLayoutTransform);
			draw();
		}
		
		[Bindable("maxChanged")]
		public function get max():Number { return _max }
		
		public function get barWidth():uint { return _barWidth }
		public function set barWidth(value:uint):void {
			if (_barWidth == value) return;
			_barWidth = value;
		}
		
		public function get barGap():uint { return _barGap }
		public function set barGap(value:uint):void {
			if (_barGap == value) return;
			_barGap = value;
		}
		
		public function addValue(value:Number):void {
			values.push(value);
			draw();
		}
		
		public function clear():void {
			chart.graphics.clear();
			values.length = 0;
			_max = 0.0;
			dispatchEvent(new Event("minChanged"));
			dispatchEvent(new Event("maxChanged"));
		}
		
		protected function draw():void {
			var g:Graphics = chart.graphics;
			g.clear();
			
			if (values.length < 1 || width == 0.0) return;
			
			numValues = (width + _barGap) / (_barWidth + _barGap);
			while (values.length > numValues) values.shift();
			
			var v:Number, i:uint, len:uint = values.length;
			
			// find max value
			var max:Number = Number.NEGATIVE_INFINITY;
			for (i = 0; i < len; ++i) {
				v = values[i];
				if (v > max) max = v;
			}
			
			// draw bars
			var h:Number;
			for (i = 0; i < len; ++i) {
				v = values[i];
				h = v / max * height;
				if (isNaN(h) || h == 0.0) {
					h = 1.0;
					g.beginFill(BAR_NO_CHANGES_COLOR);
				} else {
					g.beginFill(BAR_COLOR);
				}
				g.drawRect(i * (_barWidth + _barGap), height, _barWidth, -Math.round(h));
			}
			
			// align chart to the right
			chart.x = width - chart.width;
			
			// dispatch max changed
			if (_max != max) {
				_max = max;
				dispatchEvent(new Event("maxChanged"));
			}
		}
		
	}
	
}
