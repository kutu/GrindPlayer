package ru.kutu.grindplayer.utils {

	import flash.display.Graphics;
	import flash.geom.Point;

	public function drawCircleSector(g:Graphics, centerX:Number, centerY:Number, radius:Number, angle:Number, innerRadius:Number = 0.0):void {
		const rad:Number = Math.PI / 180.0;
		const pi2:Number = Math.PI / 2.0;
		var p:Point, i:int;

		g.moveTo(centerX, 0);
		for (i = 0; i <= angle; ++i) {
			p = Point.polar(radius, i * rad - pi2);
			g.lineTo(centerX + p.x, centerY + p.y);
		}

		if (innerRadius != 0 && innerRadius < radius) {
			for (i = angle; i >= 0; --i) {
				p = Point.polar(innerRadius, i * rad - pi2);
				g.lineTo(centerX + p.x, centerY + p.y);
			}
		}
	}

}
