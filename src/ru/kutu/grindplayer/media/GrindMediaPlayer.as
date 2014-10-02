package ru.kutu.grindplayer.media {
	
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	
	import ru.kutu.grind.media.GrindMediaPlayerBase;
	import ru.kutu.osmf.subtitles.SubtitlesEvent;
	import ru.kutu.osmf.subtitles.SubtitlesSourceItem;
	import ru.kutu.osmf.subtitles.SubtitlesTrait;
	
	public class GrindMediaPlayer extends GrindMediaPlayerBase {
		
		private var _hasSubtitles:Boolean;
		
		public function get hasSubtitles():Boolean {
			return _hasSubtitles;
		}
		
		public function get currentSubtitlesStreamIndex():int {
			return hasSubtitles ? (getTraitOrThrow(SubtitlesTrait.SUBTITLES) as SubtitlesTrait).currentIndex : -1;
		}
		
		public function get numSubtitlesStreams():int {
			return hasSubtitles ? (getTraitOrThrow(SubtitlesTrait.SUBTITLES) as SubtitlesTrait).numSubtitles : 0;
		}
		
		public function getSubtitlesItemAt(index:int):SubtitlesSourceItem {
			return (getTraitOrThrow(SubtitlesTrait.SUBTITLES) as SubtitlesTrait).getItemForIndex(index);
		}
		
		public function switchSubtitlesIndex(index:int):void {
			(getTraitOrThrow(SubtitlesTrait.SUBTITLES) as SubtitlesTrait).switchTo(index);
		}
		
		override protected function updateTraitListeners(traitType:String, add:Boolean):void {
			super.updateTraitListeners(traitType, add);
			
			switch (traitType) {
				case SubtitlesTrait.SUBTITLES:
					var subtitlesTrait:SubtitlesTrait = SubtitlesTrait(media.getTrait(SubtitlesTrait.SUBTITLES));
					if (subtitlesTrait.switching && add) {
						dispatchEvent(new SubtitlesEvent(SubtitlesEvent.SUBTITLES_SWITCHING_CHANGE, false, false, subtitlesTrait.switching && add));
					}
					dispatchEvent(new SubtitlesEvent(SubtitlesEvent.NUM_SUBTITLES_STREAMS_CHANGE, false, false, subtitlesTrait.switching && add));
					break;
			}
		}
		
		override protected function updateCapabilityForTrait(traitType:String, capabilityAdd:Boolean):void {
			super.updateCapabilityForTrait(traitType, capabilityAdd);
			
			var eventType:String = null;
			
			switch (traitType) {
				case SubtitlesTrait.SUBTITLES:
					eventType = SubtitlesEvent.HAS_SUBTITLES_CHANGE;
					_hasSubtitles = capabilityAdd;
					break;
			}
			
			if (eventType != null) {
				dispatchEvent
				( new MediaPlayerCapabilityChangeEvent
					( eventType
						, false
						, false
						, capabilityAdd
					)
				);
			}
		}
		
	}
	
}
