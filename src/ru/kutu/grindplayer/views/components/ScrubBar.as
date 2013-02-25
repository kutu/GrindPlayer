package ru.kutu.grindplayer.views.components {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.events.FlexEvent;
	
	import ru.kutu.grind.events.ScrubBarEvent;
	import ru.kutu.grind.events.ScrubBarTipEvent;
	import ru.kutu.grind.views.api.IFullScreenState;
	import ru.kutu.grind.views.api.IScrubBar;
	import ru.kutu.grind.views.api.IScrubBarTip;
	import ru.kutu.grindplayer.views.mediators.api.IScrubBarMinimized;
	
	import spark.components.Group;
	import spark.components.HSlider;
	import spark.events.TrackBaseEvent;
	
	public class ScrubBar extends HSlider implements IFullScreenState, IScrubBar, IScrubBarMinimized {
		
		[SkinPart]
		public var scrubBarTip:ScrubBarTip;
		
		[SkinPart]
		public var loadedBar:Group;
		
		protected var isFullScreen:Boolean;
		protected var isMinimized:Boolean;
		protected var _percentLoaded:Number;
		
		public function ScrubBar() {
			super();
			addEventListener(FlexEvent.CHANGE_START, onSliderChangeStart);
			addEventListener(FlexEvent.CHANGE_END, onSliderChangeEnd);
			addEventListener(Event.CHANGE, onSliderChange);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		override public function set visible(value:Boolean):void {
			super.visible = includeInLayout = value;
		}
		
		public function get tip():IScrubBarTip {
			return scrubBarTip;
		}
		
		public function set fullScreen(value:Boolean):void {
			isFullScreen = value;
			invalidateSkinState();
		}
		
		public function get percentLoaded():Number { return _percentLoaded }
		public function set percentLoaded(value:Number):void {
			_percentLoaded = value;
			loadedBar.percentWidth = value * 100.0;
		}
		
		public function minimize(value:Boolean):void {
			isMinimized = value;
			invalidateSkinState();
		}
		
		public function calcPointToValue(p:Point):Number {
			return nearestValidValue(pointToValue(p.x, p.y), snapInterval);
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			if (instance == scrubBarTip) {
				scrubBarTip.owner = this;
				scrubBarTip.isPopUp = true;
				systemManager.toolTipChildren.addChild(scrubBarTip);
			}
			super.partAdded(partName, instance);
		}
		
		override protected function getCurrentSkinState():String {
			return (isMinimized ? "minimized" : super.getCurrentSkinState()) + (isFullScreen ? "AndFullScreen" : "");
		}
		
		override protected function system_mouseMoveHandler(event:MouseEvent):void {
			if (!track || !thumb) return;
			
			var p:Point = track.globalToLocal(new Point(event.stageX, event.stageY));
			var newValue:Number = pointToValue(p.x - thumb.width / 2, p.y - thumb.height / 2);
			newValue = nearestValidValue(newValue, snapInterval);
			
			if (newValue != value) {
				setValue(newValue);
				dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
			}
			
			event.updateAfterEvent();
		}
		
		override protected function thumb_mouseDownHandler(event:MouseEvent):void {
			system_mouseMoveHandler(event);
			super.thumb_mouseDownHandler(event);
		}
		
		override protected function track_mouseDownHandler(event:MouseEvent):void {
			dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
			thumb.dispatchEvent(event);
			super.track_mouseDownHandler(event);
		}
		
		protected function onSliderChangeStart(event:FlexEvent):void {
			dispatchEvent(new ScrubBarEvent(ScrubBarEvent.SLIDER_CHANGE_START));
		}
		
		protected function onSliderChangeEnd(event:FlexEvent):void {
			dispatchEvent(new ScrubBarEvent(ScrubBarEvent.SLIDER_CHANGE_END));
		}
		
		protected function onSliderChange(event:Event):void {
			dispatchEvent(new ScrubBarEvent(ScrubBarEvent.SLIDER_CHANGE));
		}
		
		// FOR SCRUB BAR TIP
		
		private var isMouseOverTrack:Boolean;
		private var mouseMovePending:Boolean;
		private var mostRecentTrackPoint:Point = new Point();
		private var isTipVisible:Boolean;
		
		private function showTip():void {
			if (isTipVisible) return;
			isTipVisible = true;
			dispatchEvent(new ScrubBarEvent(ScrubBarEvent.SHOW_TIP));
			updateScrubBarTip();
			scrubBarTip.validateNow();
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			systemManager.getSandboxRoot().stage.addEventListener(Event.RESIZE, onSystemResize);
			systemManager.getSandboxRoot().stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		public function hideTip(immediate:Boolean = false):void {
			if (!isTipVisible) return;
			if (immediate && mouseMovePending) {
				mouseMovePending = false;
				removeEventListener(Event.ENTER_FRAME, onMousePending);
			}
			isTipVisible = false;
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			systemManager.getSandboxRoot().stage.removeEventListener(Event.RESIZE, onSystemResize);
			systemManager.getSandboxRoot().stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			dispatchEvent(new ScrubBarEvent(immediate ? ScrubBarEvent.HIDE_TIP_IMMEDIATE : ScrubBarEvent.HIDE_TIP));
		}
		
		private function onSystemResize(event:Event):void {
			hideTip(true);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			isMouseOverTrack = track.hitTestPoint(event.stageX, event.stageY, true);
			
			if (isMouseOverTrack) {
				updateMostRecentTrackPoint();
				if (isTipVisible) {
					if (!mouseMovePending) {
						mouseMovePending = true;
						addEventListener(Event.ENTER_FRAME, onMousePending);
					}
				} else {
					showTip();
				}
			} else {
				hideTip();
			}
		}
		
		private function onMousePending(event:Event):void {
			mouseMovePending = false;
			removeEventListener(Event.ENTER_FRAME, onMousePending);
			updateScrubBarTip();
		}
		
		private function onMouseLeave(event:Event):void {
			hideTip();
		}
		
		private function updateMostRecentTrackPoint():void {
			var thumbRange:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
			var thumbW:Number = thumb ? thumb.width : 0;
			var thumbH:Number = thumb ? thumb.height : 0;
			var p:Point = mostRecentTrackPoint;
			p.x = track.mouseX - (thumbW / 2);
			p.y = track.mouseY - (thumbH / 2);
			p.x = Math.max(0, p.x);
			p.x = Math.min(thumbRange, p.x);
		}
		
		private function updateScrubBarTip():void {
			var thumbW:Number = thumb ? thumb.width : 0;
			var value:Number = calcPointToValue(mostRecentTrackPoint);
			var pt:Point = track.localToGlobal(new Point(mostRecentTrackPoint.x + thumbW / 2, 0));
			dispatchEvent(new ScrubBarTipEvent(ScrubBarTipEvent.TIP_DATA_UPDATE, value, pt));
		}
		
	}
	
}
