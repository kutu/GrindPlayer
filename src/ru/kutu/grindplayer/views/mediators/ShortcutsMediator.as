package ru.kutu.grindplayer.views.mediators {
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import ru.kutu.grind.events.StatInfoEvent;
	import ru.kutu.grind.views.mediators.ShortcutsBaseMediator;
	import ru.kutu.grindplayer.events.PlayerVideoZoomEvent;
	
	public class ShortcutsMediator extends ShortcutsBaseMediator {
		
		override protected function onKeyDown(event:KeyboardEvent):void {
			super.onKeyDown(event);
			
			switch (event.keyCode) {
				// zoom in
				case Keyboard.EQUAL:
				case Keyboard.NUMPAD_ADD:
					dispatch(new PlayerVideoZoomEvent(PlayerVideoZoomEvent.ZOOM_IN));
					break;
				
				// zoom out
				case Keyboard.MINUS:
				case Keyboard.NUMPAD_SUBTRACT:
					dispatch(new PlayerVideoZoomEvent(PlayerVideoZoomEvent.ZOOM_OUT));
					break;
			}
		}
		
		override protected function onKeyUp(event:KeyboardEvent):void {
			super.onKeyUp(event);
			
			switch (event.keyCode) {
				// locale
				case Keyboard.L:
					var resourceManager:IResourceManager = ResourceManager.getInstance();
					var localeChain:Array = resourceManager.localeChain;
					resourceManager.localeChain.unshift(resourceManager.localeChain.pop());
					resourceManager.localeChain = localeChain;
					break;
				
				// stat info
				case Keyboard.T:
					dispatch(new StatInfoEvent(StatInfoEvent.TOGGLE));
					break;
				
				// zoom reset
				case Keyboard.NUMBER_0:
				case Keyboard.NUMPAD_0:
					dispatch(new PlayerVideoZoomEvent(PlayerVideoZoomEvent.ZOOM_RESET));
					break;
			}
		}
		
	}
	
}
