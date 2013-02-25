package ru.kutu.grindplayer.views.components {
	
	import flash.display.Graphics;
	import flash.display.Shape;
	
	import mx.preloaders.SparkDownloadProgressBar;
	
	import ru.kutu.grindplayer.utils.drawCircleSector;
	
	public class Preloader extends SparkDownloadProgressBar {
		
		private const RADIUS:int = 18;
		private const INNER_RADIUS:int = 12;
		
		private var circleBg:Shape;
		private var circleSector:Shape;
		private var lastCompleted:Number;
		
		override protected function createChildren():void {
			circleBg = new Shape();
			circleBg.graphics.beginFill(0x474747);
			drawCircleSector(circleBg.graphics, 0, 0, RADIUS, 360, INNER_RADIUS);
			addChild(circleBg);
			
			circleSector = new Shape();
			addChild(circleSector);
			
			circleBg.x = circleSector.x = stageWidth >> 1;
			circleBg.y = circleSector.y = stageHeight >> 1;
		}
		
		override protected function setDownloadProgress(completed:Number, total:Number):void {
			if (!circleSector) return;
			circleSector.rotation += 4;
			
			if (lastCompleted == completed) return;
			
			var g:Graphics = circleSector.graphics;
			g.clear();
			g.beginFill(0x757575);
			drawCircleSector(g, 0, 0, RADIUS, 360 * completed / total, INNER_RADIUS);
			
			lastCompleted = completed;
		}
		
		override protected function setInitProgress(completed:Number, total:Number):void {
		}
		
	}
	
}
