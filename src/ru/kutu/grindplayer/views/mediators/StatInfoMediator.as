package ru.kutu.grindplayer.views.mediators {
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenuItem;
	
	import mx.resources.ResourceManager;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	
	import ru.kutu.grind.views.mediators.StatInfoBaseMediator;
	
	public class StatInfoMediator extends StatInfoBaseMediator {
		
		[Inject] public var contextView:ContextView;
		
		private var cmItem:ContextMenuItem;
		
		override public function initialize():void {
			super.initialize();
			
			// context menu item
			cmItem = new ContextMenuItem(null);
			cmItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuShowStatInfo);
			contextView.view.contextMenu.customItems.push(cmItem);
			
			// localization "show statistics" caption
			ResourceManager.getInstance().addEventListener(Event.CHANGE, onResourceManagerChange);
			onResourceManagerChange();
		}
		
		override protected function set visible(value:Boolean):void {
			super.visible = value;
			cmItem.enabled = !value;
		}
		
		private function onResourceManagerChange(event:Event = null):void {
			cmItem.caption = ResourceManager.getInstance().getString("Main", "showStatInfo");
		}
		
		private function onContextMenuShowStatInfo(event:ContextMenuEvent):void {
			visible = true;
		}
		
	}
	
}
