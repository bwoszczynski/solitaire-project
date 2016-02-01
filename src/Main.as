package
{
	import com.mesmotronic.ane.AndroidFullScreen;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.InvokeEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import manager.GameManager;
	import manager.GlobalDispatcher;
	import minigame.logic.LogicHelper;
	import player.PlayerModel;
	
	/**
	 * ...
	 * @author Steel Feather Bartosz Woszczyński
	 * 			
	 */
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF", width="1024", height="768")]
	public class Main extends Sprite 
	{
		static public const REMOVE_START_PRELOADER:String = "removeStartPreloader";
		[Embed(source="../assets/assets/splashLogo.png", mimeType="image/png")]
		private var SplashLogo:Class;
	
		private var _gameManager:GameManager;
		private var _startPreloader:Bitmap;
		
		public function Main() 
		{
			if (stage) 
				init(null);
			else 
				addEventListener(Event.ADDED_TO_STAGE, init);			
			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			addPreloader();
			
			_gameManager = new GameManager();
			_gameManager.init(stage);
			
			if (!AndroidFullScreen.leanMode())
			{
			   stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
				
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onAppExitHandler);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onCheckImmerse, false, 0, true);
				
			GlobalDispatcher.instance.addEventListener(REMOVE_START_PRELOADER, onRemovePreloaderHandler);
		}
		
		private function onCheckImmerse(e:Event):void 
		{			
			AndroidFullScreen.immersiveMode() || AndroidFullScreen.leanMode();
		}
		
		private function onInvoke(e:InvokeEvent):void 
		{
			AndroidFullScreen.immersiveMode() || AndroidFullScreen.leanMode();
		}
		
		private function onRemovePreloaderHandler(e:Object):void 
		{
			GlobalDispatcher.instance.removeEventListener(REMOVE_START_PRELOADER, onRemovePreloaderHandler);
			removePreloader();
		}
		
		private function addPreloader():void 
		{
			_startPreloader = new SplashLogo();
			_startPreloader.x = int(stage.stageWidth / 2 - _startPreloader.width / 2)
			_startPreloader.y = int(stage.stageHeight / 2 - _startPreloader.height / 2)
			addChild(_startPreloader);
		}
		
		private function removePreloader():void
		{
			if (_startPreloader.parent)
			{
				removeChild(_startPreloader);
			}
		}
		
		private function onAppExitHandler(e:Event):void 
		{
			if (LogicHelper.prevShuffledArray)
				PlayerModel.instance.saveGameLostData();
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}