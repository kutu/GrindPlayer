package ru.kutu.grindplayer.views.mediators {
	
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.TimelineMetadataEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.TimelineMetadata;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	
	import ru.kutu.grind.views.mediators.MediaControlBaseMediator;
	import ru.kutu.grindplayer.views.components.Subtitles;
	import ru.kutu.osmf.subtitles.SubtitlesEvent;
	import ru.kutu.osmf.subtitles.SubtitlesMarker;
	import ru.kutu.osmf.subtitles.SubtitlesTrait;
	
	public class SubtitlesMediator extends MediaControlBaseMediator {
		
		[Inject] public var view:Subtitles;
		
		private var subtitlesMetadata:TimelineMetadata;
		private var currentMarker:SubtitlesMarker;
		
		private var playTrait:PlayTrait;
		private var seekTrait:SeekTrait;
		private var timeTrait:TimeTrait;
		private var subtitlesTrait:SubtitlesTrait;
		
		private var _requiredTraits:Vector.<String> = new <String>[MediaTraitType.TIME, SubtitlesTrait.SUBTITLES];
		
		override protected function get requiredTraits():Vector.<String> {
			return _requiredTraits;
		}
		
		override protected function processMediaElementChange(oldMediaElement:MediaElement):void {
			if (oldMediaElement) {
				if (playTrait) {
					playTrait.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
					playTrait = null;
				}
				if (seekTrait) {
					seekTrait.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
					seekTrait = null;
				}
				timeTrait = null;
				if (subtitlesTrait) {
					subtitlesTrait.removeEventListener(SubtitlesEvent.SUBTITLES_SWITCHING_CHANGE, onSwitchChange);
					subtitlesTrait = null;
				}
				
				oldMediaElement.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				oldMediaElement.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
				
				view.visible = false;
			}
			if (media) {
				media.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				media.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
			}
		}
		
		override protected function processRequiredTraitsAvailable(element:MediaElement):void {
			playTrait = element.getTrait(MediaTraitType.PLAY) as PlayTrait;
			if (playTrait) {
				playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
			}
			
			seekTrait = element.getTrait(MediaTraitType.SEEK) as SeekTrait;
			if (seekTrait) {
				seekTrait.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
			}
			
			timeTrait = element.getTrait(MediaTraitType.TIME) as TimeTrait;
			
			subtitlesTrait = element.getTrait(SubtitlesTrait.SUBTITLES) as SubtitlesTrait;
			if (subtitlesTrait) {
				subtitlesTrait.addEventListener(SubtitlesEvent.SUBTITLES_SWITCHING_CHANGE, onSwitchChange);
			}
		}
		
		override protected function processRequiredTraitsUnavailable(element:MediaElement):void {
			if (playTrait) {
				playTrait.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
				playTrait = null;
			}
			
			if (seekTrait) {
				seekTrait.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
				seekTrait = null;
			}
			
			timeTrait = null;
			
			if (subtitlesTrait) {
				subtitlesTrait.removeEventListener(SubtitlesEvent.SUBTITLES_SWITCHING_CHANGE, onSwitchChange);
				subtitlesTrait = null;
			}
			
			view.visible = false;
		}
		
		private function onSwitchChange(event:SubtitlesEvent):void {
			if (!subtitlesTrait) return;
			
			if (subtitlesMetadata) {
				subtitlesMetadata.removeEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onMarkerTimeReached);
				subtitlesMetadata.removeEventListener(TimelineMetadataEvent.MARKER_DURATION_REACHED, onMarkerDurationReached);
				subtitlesMetadata = null;
				currentMarker = null;
				view.visible = false;
			}
			
			if (event.switching) {
				view.visible = false;
			} else if (subtitlesTrait.currentIndex != -1) {
				subtitlesMetadata = subtitlesTrait.getItemForIndex(subtitlesTrait.currentIndex).subtitlesMetadata as TimelineMetadata;
				subtitlesMetadata.addEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onMarkerTimeReached);
				subtitlesMetadata.addEventListener(TimelineMetadataEvent.MARKER_DURATION_REACHED, onMarkerDurationReached);
				findCurrentMarker();
			}
		}
		
		private function onMarkerTimeReached(event:TimelineMetadataEvent):void {
			var marker:SubtitlesMarker = event.marker as SubtitlesMarker;
			currentMarker = marker;
			view.label.text = currentMarker.text;
			view.visible = true;
			view.update();
		}
		
		private function onMarkerDurationReached(event:TimelineMetadataEvent):void {
			var marker:SubtitlesMarker = event.marker as SubtitlesMarker;
			if (marker == currentMarker) {
				currentMarker = null;
				view.visible = false;
			}
		}
		
		private function onTraitAdd(event:MediaElementEvent):void {
			switch (event.traitType) {
				case MediaTraitType.PLAY:
					playTrait = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
					playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
					break;
				case MediaTraitType.SEEK:
					seekTrait = media.getTrait(MediaTraitType.SEEK) as SeekTrait;
					seekTrait.addEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
					break;
				case MediaTraitType.TIME:
					timeTrait = media.getTrait(MediaTraitType.TIME) as TimeTrait;
					break;
			}
		}
		
		private function onTraitRemove(event:MediaElementEvent):void {
			switch (event.traitType) {
				case MediaTraitType.PLAY:
					if (playTrait) {
						playTrait.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, onPlayStateChange);
						playTrait = null;
					}
					break;
				case MediaTraitType.SEEK:
					if (seekTrait) {
						seekTrait.removeEventListener(SeekEvent.SEEKING_CHANGE, onSeekingChange);
						seekTrait = null;
					}
					break;
				case MediaTraitType.TIME:
					timeTrait = null;
					break;
			}
		}
		
		private function onPlayStateChange(event:PlayEvent):void {
			if (!subtitlesTrait) return;
			if (event.playState == PlayState.PLAYING) {
				findCurrentMarker();
			}
		}
		
		private function onSeekingChange(event:SeekEvent):void {
			if (!subtitlesTrait) return;
			if (!event.seeking) {
				findCurrentMarker();
			}
		}
		
		private function findCurrentMarker():void {
			if (!subtitlesMetadata || !timeTrait) return;
			var time:Number = timeTrait.currentTime;
			var marker:SubtitlesMarker;
			for (var i:uint = 0, len:uint = subtitlesMetadata.numMarkers; i < len; ++i) {
				marker = subtitlesMetadata.getMarkerAt(i) as SubtitlesMarker;
				if (marker && marker.time <= time && marker.time + marker.duration > time) {
					if (marker == currentMarker) return;
					currentMarker = marker;
					view.label.text = currentMarker.text;
					view.visible = true;
					view.update();
					return;
				}
			}
			currentMarker = null;
			view.visible = false;
		}
		
	}
	
}
