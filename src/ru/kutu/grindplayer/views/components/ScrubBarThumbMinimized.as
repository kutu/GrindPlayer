package ru.kutu.grindplayer.views.components {
	
	import spark.components.Button;
	
	[SkinState("minimized")]
	
	public class ScrubBarThumbMinimized extends Button {
		
		private var _minimized:Boolean;
		
		public function ScrubBarThumbMinimized() {
			super();
		}
		
		[Bindable]
		public function get minimized():Boolean { return _minimized }
		public function set minimized(value:Boolean):void {
			if (_minimized == value) return;
			_minimized = value;
			invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String {
			return _minimized ? "minimized" : super.getCurrentSkinState();
		}
		
	}
	
}
