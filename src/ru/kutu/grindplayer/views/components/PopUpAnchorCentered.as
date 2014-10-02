package ru.kutu.grindplayer.views.components {
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.components.PopUpAnchor;
	
	public class PopUpAnchorCentered extends PopUpAnchor {
		
		public function PopUpAnchorCentered() {
			super();
		}
		
		override protected function determinePosition(placement:String, popUpWidth:Number, popUpHeight:Number, matrix:Matrix, registrationPoint:Point, bounds:Rectangle):void {
			registrationPoint.x = (unscaledWidth - popUpWidth) / 2;
			registrationPoint.y = -popUpHeight;
			super.determinePosition("", popUpWidth, popUpHeight, matrix, registrationPoint, bounds);
		}
		
	}
	
}
