package ru.kutu.grindplayer.views.skins.helpers {

	import flash.geom.ColorTransform;

	import spark.primitives.BitmapImage;

	public class ColorizedBitmapImage extends BitmapImage {

		private var _color:Object;

		public function get color():Object { return _color; }
		public function set color(value:Object):void {
			if (_color == value) return;
			_color = value;
			var ct:ColorTransform = transform.colorTransform;
			if (value && value >= 0) {
				var col:uint = uint(color);
				ct.redMultiplier = (col >> 16 & 0xFF) / 256.0
				ct.greenMultiplier = (col >> 8 & 0xFF) / 256.0
				ct.blueMultiplier = (col & 0xFF) / 256.0
				transform.colorTransform = ct;
			} else {
				transform.colorTransform = null;
			}
		}

	}

}
