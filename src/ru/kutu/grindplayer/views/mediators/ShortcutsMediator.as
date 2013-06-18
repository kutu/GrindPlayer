package ru.kutu.grindplayer.views.mediators {
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import ru.kutu.grind.events.StatInfoEvent;
	import ru.kutu.grind.views.mediators.ShortcutsBaseMediator;
	
	public class ShortcutsMediator extends ShortcutsBaseMediator {
		
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
			}
		}
		
	}
	
}
