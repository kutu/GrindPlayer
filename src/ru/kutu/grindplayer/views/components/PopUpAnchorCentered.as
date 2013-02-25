package ru.kutu.grindplayer.views.components {
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.mx_internal;
	
	import spark.components.PopUpAnchor;
	
	use namespace mx_internal;
	
	public class PopUpAnchorCentered extends PopUpAnchor {
		
		public function PopUpAnchorCentered() {
			super();
		}
		
		mx_internal override function determinePosition(placement:String, popUpWidth:Number, popUpHeight:Number, matrix:Matrix, registrationPoint:Point, bounds:Rectangle):void {
			registrationPoint.x = (unscaledWidth - popUpWidth) / 2;
			registrationPoint.y = -popUpHeight;
			super.determinePosition("", popUpWidth, popUpHeight, matrix, registrationPoint, bounds);
		}
		
	}
	
}
