package ru.kutu.grindplayer.views.skins.helpers {
	
	import mx.graphics.SolidColor;
	
	import spark.primitives.Rect;
	
	public class HitArea extends Rect {
		
		public function HitArea() {
			super();
			left = right = top = bottom = 0;
			fill = new SolidColor(0, 0.0);
		}
		
	}
	
}
