package ru.kutu.grindplayer.views.mediators {
	
	import flash.events.Event;
	
	import org.osmf.media.MediaElement;
	
	import ru.kutu.grind.events.ControlBarMenuChangeEvent;
	import ru.kutu.grind.views.mediators.ControlBarMenuBaseMediator;
	import ru.kutu.grind.vos.LanguageSelectorVO;
	import ru.kutu.grind.vos.SelectorVO;
	import ru.kutu.grindplayer.views.mediators.api.ISubtitlesMenuButton;
	import ru.kutu.osmf.subtitles.SubtitlesEvent;
	import ru.kutu.osmf.subtitles.SubtitlesSourceItem;
	import ru.kutu.osmf.subtitles.SubtitlesTrait;
	
	public class SubtitlesMenuMediator extends ControlBarMenuBaseMediator {
		
		[Inject] public var view:ISubtitlesMenuButton;
		
		private var subtitlesTrait:SubtitlesTrait;
		
		private var _requiredTraits:Vector.<String> = new <String>[SubtitlesTrait.SUBTITLES];
		
		override protected function get requiredTraits():Vector.<String> {
			return _requiredTraits;
		}
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void {
			subtitlesTrait = element.getTrait(SubtitlesTrait.SUBTITLES) as SubtitlesTrait;
			if (subtitlesTrait) {
				subtitlesTrait.addEventListener(SubtitlesEvent.SUBTITLES_SWITCHING_CHANGE, onSwitchChange);
				onNumStreamChange();
				view.visible = true;
			}
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void {
			if (subtitlesTrait) {
				subtitlesTrait.removeEventListener(SubtitlesEvent.SUBTITLES_SWITCHING_CHANGE, onSwitchChange);
				subtitlesTrait = null;
			}
			view.closeDropDown(false);
			view.visible = false;
		}
		
		override protected function onNumStreamChange(event:Event = null):void {
			if (!subtitlesTrait) return;
			
			var items:Array = new Array();
			
			var subtitlesItem:SubtitlesSourceItem;
			for (var i:uint = 0; i < subtitlesTrait.numSubtitles; ++i) {
				subtitlesItem = subtitlesTrait.getItemForIndex(i);
				items.push({
					index: i
					, value: subtitlesItem.label || subtitlesItem.language
					, subtitlesItem: subtitlesItem
				});
			}
			
			items.sortOn("value", Array.CASEINSENSITIVE);
			
			selectors.length = 0;
			selectors.push(new LanguageSelectorVO(-1));
			
			for each (var item:Object in items) {
				selectors.push(new LanguageSelectorVO(item.index, processLabelForSelectorVO(item), item.subtitlesItem.language));
			}
			
			view.setSelectors(selectors);
			
			super.onNumStreamChange();
		}
		
		override protected function onSwitchChange(event:Event = null):void {
			if (!subtitlesTrait) return;
			
			var vo:SelectorVO = getSelectorVOByIndex(subtitlesTrait.currentIndex);
			if (vo) {
				view.selectedIndex = selectors.indexOf(vo);
			}
		}
		
		override protected function onMenuChange(event:ControlBarMenuChangeEvent):void {
			if (!subtitlesTrait) return;
			
			var vo:SelectorVO = selectors[view.selectedIndex];
			if (vo) {
				subtitlesTrait.switchTo(vo.index);
			}
		}
		
		override protected function processLabelForSelectorVO(item:Object):String {
			var subtitlesItem:SubtitlesSourceItem = item.subtitlesItem as SubtitlesSourceItem;
			return subtitlesItem.label || subtitlesItem.language;
		}
		
	}
	
}
