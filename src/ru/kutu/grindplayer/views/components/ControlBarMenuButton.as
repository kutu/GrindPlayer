package ru.kutu.grindplayer.views.components {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import ru.kutu.grind.events.ControlBarMenuChangeEvent;
	import ru.kutu.grind.events.ControlBarMenuEvent;
	import ru.kutu.grind.views.api.IControlBarMenuButtonHide;
	import ru.kutu.grind.vos.SelectorVO;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.supportClasses.DropDownController;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	
	public class ControlBarMenuButton extends SkinnableComponent implements IControlBarMenuButtonHide {
		
		[SkinPart(required="true")]
		public var dropDown:DisplayObject;
		
		[SkinPart(required="true")]
		public var list:List;
		
		[SkinPart(required="true")]
		public var openButton:Button;
		
		private var dropDownController:DropDownController;
		
		public function ControlBarMenuButton() {
			super();
			mouseEnabled = false;
			dropDownController = new DropDownController();
			dropDownController.rollOverOpenDelay = 0;
			dropDownController.addEventListener(DropDownEvent.OPEN, onDropDownOpen);
			dropDownController.addEventListener(DropDownEvent.CLOSE, onDropDownClose);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function openDropDown():void {
			dropDownController.openDropDown();
		}
		
		public function closeDropDown(commit:Boolean):void {
			dropDownController.closeDropDown(commit);
		}
		
		public function setSelectors(list:Vector.<SelectorVO>):void {
			var col:ArrayCollection = new ArrayCollection();
			for each (var vo:SelectorVO in list) {
				col.addItem(vo);
			}
			this.list.dataProvider = col;
		}
		
		public function getSelectorVOByIndex(index:int = -1):SelectorVO {
			if (!list || !list.dataProvider || list.dataProvider.length == 0) return null;
			var len:int = list.dataProvider.length;
			for (var i:int = 0; i < len; ++i) {
				var vo:SelectorVO = list.dataProvider.getItemAt(i) as SelectorVO;
				if (vo.index == index) return vo;
			}
			return null;
		}
		
		public function get selectedIndex():int { return list.selectedIndex }
		public function set selectedIndex(value:int):void {
			list.selectedIndex = value;
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == openButton) {
				dropDownController.openButton = openButton;
			} else if (instance == dropDown) {
				dropDownController.dropDown = dropDown;
			}
			
			if (instance == list) {
				list.addEventListener(IndexChangeEvent.CHANGE, onListChange);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			if (dropDownController) {
				if (instance == openButton)
					dropDownController.openButton = null;
				
				if (instance == dropDown)
					dropDownController.dropDown = null;
			}
			
			super.partRemoved(partName, instance);
		}
		
		override protected function getCurrentSkinState():String {
			return !enabled ? "disabled" : dropDownController.isOpen ? "open" : "normal";
		}
		
		override public function set visible(value:Boolean):void {
			super.visible = includeInLayout = value;
		}
		
		protected function onListChange(event:IndexChangeEvent):void {
			closeDropDown(true);
			dispatchEvent(new ControlBarMenuChangeEvent(ControlBarMenuChangeEvent.CHANGE, event.newIndex));
		}
		
		protected function onDropDownOpen(event:DropDownEvent):void {
			invalidateSkinState();
			dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
			dispatchEvent(new ControlBarMenuEvent(ControlBarMenuEvent.DROPDOWN_OPEN));
		}
		
		protected function onDropDownClose(event:DropDownEvent):void {
			invalidateSkinState();
			dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
			dispatchEvent(new ControlBarMenuEvent(ControlBarMenuEvent.DROPDOWN_CLOSE));
		}
		
		protected function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		protected function onMouseLeave(event:Event):void {
			closeDropDown(false);
		}
		
	}
	
}
