package ru.kutu.grindplayer.views.components {
	
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
	import ru.kutu.grind.views.api.IQualityMenuButton;
	import ru.kutu.grind.vos.QualitySelectorVO;
	import ru.kutu.grind.vos.SelectorVO;
	
	public class QualityMenuButton extends ControlBarMenuButton implements IQualityMenuButton {
		
		private var _currentIndex:int = -1;
		
		public function QualityMenuButton() {
			super();
			
			// localization "auto" label
			ResourceManager.getInstance().addEventListener(Event.CHANGE, onResourceManagerChange);
		}
		
		public function set currentIndex(value:int):void {
			if (value == _currentIndex) return;
			
			var vo:SelectorVO;
			if (_currentIndex > -1) {
				vo = getSelectorVOByIndex(_currentIndex);
				if (vo) {
					vo.isCurrent = false;
					list.dataProvider.itemUpdated(vo);
				}
			}
			
			_currentIndex = value;
			
			vo = getSelectorVOByIndex(value);
			if (!vo) return;
			vo.isCurrent = true;
			list.dataProvider.itemUpdated(vo);
		}
		
		override public function setSelectors(list:Vector.<SelectorVO>):void {
			super.setSelectors(list);
			onResourceManagerChange();
		}
		
		private function onResourceManagerChange(event:Event = null):void {
			var vo:SelectorVO = getSelectorVOByIndex();
			if (!vo) return;
			vo.label = ResourceManager.getInstance().getString("Main", "qualitiesAuto");
			list.dataProvider.itemUpdated(vo);
		}
		
	}
	
}
