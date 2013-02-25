package ru.kutu.grindplayer.views.components {
	
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
	import ru.kutu.grind.vos.SelectorVO;
	import ru.kutu.grindplayer.views.mediators.api.ISubtitlesMenuButton;
	
	public class SubtitlesMenuButton extends ControlBarMenuButton implements ISubtitlesMenuButton {
		
		public function SubtitlesMenuButton() {
			super();
			
			// localization "off" label
			ResourceManager.getInstance().addEventListener(Event.CHANGE, onResourceManagerChange);
		}
		
		override public function setSelectors(list:Vector.<SelectorVO>):void {
			super.setSelectors(list);
			onResourceManagerChange();
		}
		
		private function onResourceManagerChange(event:Event = null):void {
			var vo:SelectorVO = getSelectorVOByIndex();
			if (!vo) return;
			vo.label = ResourceManager.getInstance().getString("Main", "subtitlesOff");
			list.dataProvider.itemUpdated(vo);
		}
		
	}
	
}
