package ru.kutu.grindplayer.config {
	
	import robotlegs.bender.extensions.contextView.ContextViewExtension;
	import robotlegs.bender.extensions.contextView.ContextViewListenerConfig;
	import robotlegs.bender.extensions.contextView.StageSyncExtension;
	import robotlegs.bender.extensions.enhancedLogging.InjectableLoggerExtension;
	import robotlegs.bender.extensions.enhancedLogging.TraceLoggingExtension;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
	import robotlegs.bender.extensions.localEventMap.LocalEventMapExtension;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
	import robotlegs.bender.extensions.viewManager.StageObserverExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.framework.api.IBundle;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	
	public class GrindBundle implements IBundle {
		
		public function extend(context:IContext):void {
			context.logLevel = LogLevel.DEBUG;

			CONFIG::DEV {
				context.install(TraceLoggingExtension);
			}
			
			context.install(
				InjectableLoggerExtension,
				ContextViewExtension,
				EventDispatcherExtension,
				LocalEventMapExtension,
				ViewManagerExtension,
				StageObserverExtension,
				MediatorMapExtension,
				StageSyncExtension
			);
			
			context.configure(ContextViewListenerConfig);
		}
		
	}
	
}
