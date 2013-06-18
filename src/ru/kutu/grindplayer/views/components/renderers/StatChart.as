package ru.kutu.grindplayer.views.components.renderers {
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import spark.core.SpriteVisualElement;
	
	public class StatChart extends SpriteVisualElement {
		
		protected static const STROKE_COLORS:Array = [0x666666, 0xFFFFFF];
		protected static const STROKE_ALPHAS:Array = [1.0, 1.0];
		protected static const STROKE_RATIOS:Array = [0xCC, 0xFF];
		
		protected static const FILL_COLORS:Array = [0x3333FF, 0xFF3333];
		protected static const FILL_ALPHAS:Array = [0.3, 0.6];
		protected static const FILL_RATIOS:Array = [0x0, 0xFF];
		
		protected const values:Vector.<Number> = new Vector.<Number>();
		protected const chart:Shape = new Shape();
		protected const m:Matrix = new Matrix();
		
		protected var numValues:uint;
		
		protected var _min:Number = 0.0;
		protected var _max:Number = 0.0;
		protected var _pointGap:uint = 2;
		
		public function StatChart() {
			super();
			addChild(chart);
		}
		
		override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean=true):void {
			super.setLayoutBoundsSize(width, height, postLayoutTransform);
			draw();
		}
		
		[Bindable("minChanged")]
		public function get min():Number { return _min }
		
		[Bindable("maxChanged")]
		public function get max():Number { return _max }
		
		public function get pointGap():uint { return _pointGap }
		public function set pointGap(value:uint):void {
			if (_pointGap == value) return;
			_pointGap = value;
		}
		
		public function addValue(value:Number):void {
			values.push(value);
			draw();
		}
		
		public function clear():void {
			chart.graphics.clear();
			values.length = 0;
			_min = _max = 0.0;
			dispatchEvent(new Event("minChanged"));
			dispatchEvent(new Event("maxChanged"));
		}
		
		protected function draw():void {
			var g:Graphics = chart.graphics;
			g.clear();
			
			if (values.length < 2 || width == 0.0) return;
			
			numValues = width / _pointGap;
			while (values.length > numValues) values.shift();
			
			var v:Number, i:uint, len:uint = values.length;
			
			// find min/max value
			var max:Number = Number.NEGATIVE_INFINITY;
			var min:Number = Number.POSITIVE_INFINITY;
			for (i = 0; i < len; ++i) {
				v = values[i];
				if (v < min) min = v;
				if (v > max) max = v;
			}
			min = Math.max(0.0, Math.min(min, max - height * .5));
			
			// draw chart
			g.lineStyle(1.0, 0, 1.0, false, LineScaleMode.NONE, CapsStyle.NONE);
			m.createGradientBox(width, height, 0, -width + width / numValues * len);
			g.lineGradientStyle(GradientType.LINEAR, STROKE_COLORS, STROKE_ALPHAS, STROKE_RATIOS, m);
			m.createGradientBox(1, height, -Math.PI * 0.5);
			g.beginGradientFill(GradientType.LINEAR, FILL_COLORS, FILL_ALPHAS, FILL_RATIOS, m);
			
			var py:Number;
			for (i = 0; i < len; ++i) {
				v = values[i];
				py = height - (v - min) / (max - min) * height;
				if (isNaN(py)) {
					py = 0.0;
				}
				if (i == 0) {
					g.moveTo(0.0, py);
				} else {
					g.lineTo(i * _pointGap, py);
				}
			}
			
			g.lineStyle(0.0, 0, 0.0);
			g.lineTo((len - 1) * _pointGap, height);
			g.lineTo(0.0, height);
			
			// align chart to the right
			chart.x = width - chart.width;
			
			// dispatch min/max changed
			if (_min != min) {
				_min = min;
				dispatchEvent(new Event("minChanged"));
			}
			if (_max != max) {
				_max = max;
				dispatchEvent(new Event("maxChanged"));
			}
		}
		
	}
	
}
