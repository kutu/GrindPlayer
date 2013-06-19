package ru.kutu.grindplayer.config  {
	
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.player.configuration.ConfigurationFlashvarsDeserializer;
	import org.osmf.player.configuration.ConfigurationLoader;
	import org.osmf.player.configuration.ConfigurationProxy;
	import org.osmf.player.configuration.ConfigurationXMLDeserializer;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.ILogger;
	
	import ru.kutu.grind.config.ConfigurationProxyProvider;
	import ru.kutu.grind.config.GrindConfig;
	import ru.kutu.grind.config.JavaScriptBridgeBase;
	import ru.kutu.grind.config.LocalSettings;
	import ru.kutu.grind.config.PlayerConfiguration;
	import ru.kutu.grind.config.ResourceProvider;
	import ru.kutu.grind.media.GrindMediaFactoryBase;
	import ru.kutu.grind.views.api.IAlternateMenuButton;
	import ru.kutu.grind.views.api.IBufferInfo;
	import ru.kutu.grind.views.api.IControlBarMenuButtonHide;
	import ru.kutu.grind.views.api.IControlBarView;
	import ru.kutu.grind.views.api.IFullScreenButton;
	import ru.kutu.grind.views.api.IFullScreenState;
	import ru.kutu.grind.views.api.IMainView;
	import ru.kutu.grind.views.api.IPlayPauseButton;
	import ru.kutu.grind.views.api.IPlayerView;
	import ru.kutu.grind.views.api.IQualityMenuButton;
	import ru.kutu.grind.views.api.IScrubBar;
	import ru.kutu.grind.views.api.IScrubBarTip;
	import ru.kutu.grind.views.api.IStatInfo;
	import ru.kutu.grind.views.api.ITimeInfo;
	import ru.kutu.grind.views.api.IVolumeComponent;
	import ru.kutu.grind.views.mediators.AlternateMenuBaseMediator;
	import ru.kutu.grind.views.mediators.ControlBarBaseMediator;
	import ru.kutu.grind.views.mediators.ControlBarMenuHideBaseMediator;
	import ru.kutu.grind.views.mediators.FullScreenStateMediator;
	import ru.kutu.grind.views.mediators.FullscreenButtonBaseMediator;
	import ru.kutu.grind.views.mediators.MainViewBaseMediator;
	import ru.kutu.grind.views.mediators.PlayPauseButtonBaseMediator;
	import ru.kutu.grind.views.mediators.QualityMenuBaseMediator;
	import ru.kutu.grind.views.mediators.ScrubBarTipBaseMediator;
	import ru.kutu.grind.views.mediators.TimeInfoBaseMediator;
	import ru.kutu.grind.views.mediators.VolumeComponentBaseMediator;
	import ru.kutu.grindplayer.media.GrindMediaPlayer;
	import ru.kutu.grindplayer.views.components.Subtitles;
	import ru.kutu.grindplayer.views.mediators.AutoHideMediator;
	import ru.kutu.grindplayer.views.mediators.BufferInfoMediator;
	import ru.kutu.grindplayer.views.mediators.PlayerViewMediator;
	import ru.kutu.grindplayer.views.mediators.ScrubBarMediator;
	import ru.kutu.grindplayer.views.mediators.ScrubBarMinimizedMediator;
	import ru.kutu.grindplayer.views.mediators.ShortcutsMediator;
	import ru.kutu.grindplayer.views.mediators.StatInfoMediator;
	import ru.kutu.grindplayer.views.mediators.SubtitlesMediator;
	import ru.kutu.grindplayer.views.mediators.SubtitlesMenuMediator;
	import ru.kutu.grindplayer.views.mediators.api.IScrubBarMinimized;
	import ru.kutu.grindplayer.views.mediators.api.ISubtitlesMenuButton;
	
	import spark.components.Application;
	
	public class AppConfig extends GrindConfig {
		
		[Inject] public var contextView:ContextView;
		[Inject] public var mediatorMap:IMediatorMap;
		[Inject] public var logger:ILogger;
		
		override public function configure():void {
			super.configure();
			
			Application(contextView.view).focusManager.deactivate();
			
			injector.map(LocalSettings).asSingleton();
			injector.map(JavaScriptBridgeBase).toSingleton(JavaScriptBridge);
			
			mediatorMap.map(IMainView).toMediator(MainViewBaseMediator);
			
			mediatorMap.map(IPlayerView).toMediator(PlayerViewMediator);
			mediatorMap.map(IPlayerView).toMediator(AutoHideMediator);
			mediatorMap.map(IPlayerView).toMediator(ShortcutsMediator);
			
			mediatorMap.map(Subtitles).toMediator(SubtitlesMediator);
			mediatorMap.map(IControlBarView).toMediator(ControlBarBaseMediator);
			mediatorMap.map(IBufferInfo).toMediator(BufferInfoMediator);
			mediatorMap.map(IStatInfo).toMediator(StatInfoMediator);
			
			mediatorMap.map(IScrubBar).toMediator(ScrubBarMediator);
			mediatorMap.map(IScrubBarTip).toMediator(ScrubBarTipBaseMediator);
			mediatorMap.map(IScrubBarMinimized).toMediator(ScrubBarMinimizedMediator);
			
			mediatorMap.map(IPlayPauseButton).toMediator(PlayPauseButtonBaseMediator);
			mediatorMap.map(IVolumeComponent).toMediator(VolumeComponentBaseMediator);
			mediatorMap.map(ITimeInfo).toMediator(TimeInfoBaseMediator);
			
			mediatorMap.map(IControlBarMenuButtonHide).toMediator(ControlBarMenuHideBaseMediator);
			mediatorMap.map(ISubtitlesMenuButton).toMediator(SubtitlesMenuMediator);
			mediatorMap.map(IAlternateMenuButton).toMediator(AlternateMenuBaseMediator);
			mediatorMap.map(IQualityMenuButton).toMediator(QualityMenuBaseMediator);
			
			mediatorMap.map(IFullScreenButton).toMediator(FullscreenButtonBaseMediator);
			mediatorMap.map(IFullScreenState).toMediator(FullScreenStateMediator);
		}
		
		override protected function configuration():void {
			injector.map(PlayerConfiguration).toSingleton(GrindPlayerConfiguration);
			injector.map(MediaPlayer).toSingleton(GrindMediaPlayer);
			injector.map(MediaResourceBase).toProvider(new ResourceProvider());
			injector.map(MediaFactory).toSingleton(GrindMediaFactoryBase);
			
			injector.map(ConfigurationProxy).toProvider(new ConfigurationProxyProvider());
			injector.map(ConfigurationFlashvarsDeserializer).toValue(
				new ConfigurationFlashvarsDeserializer(
					injector.getInstance(ConfigurationProxy)
				));
			injector.map(ConfigurationXMLDeserializer).toValue(
				new ConfigurationXMLDeserializer(
					injector.getInstance(ConfigurationProxy)
				));
			injector.map(ConfigurationLoader).toValue(
				new ConfigurationLoader(
					injector.getInstance(ConfigurationFlashvarsDeserializer),
					injector.getInstance(ConfigurationXMLDeserializer)
				));
		}
		
	}
	
}
