package manager 
{
	import feathers.themes.SteelSolitaireTheme;
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import player.PlayerModel;
	import starling.core.Starling;
	import starling.events.Event;
	import treefortress.sound.SoundAS;
	import view.GlobalView;
	/**
	 * ...
	 * @author Steel Feather Bartosz Woszczyński
	 */
	public class GameManager 
	{
		private var _flashStage:Stage;
		private var _globalView:GlobalView;
		private var _starling:Starling;
		private var _sceneManager:SceneManager;
		private var _backButtonManager:BackButtonManager;
		
		public function GameManager() 
		{
			
		}
		
		public function init(flashStage:Stage):void 
		{
			_flashStage = flashStage;
			
			var viewPort : Rectangle;
			viewPort = new Rectangle(0, 0, _flashStage.stageWidth, _flashStage.stageHeight);				
			Starling.multitouchEnabled = false;
			Starling.handleLostContext = true;			
			_starling = new Starling(GlobalView, _flashStage, viewPort, null, "auto",["baselineExtended", "baseline"]);
			_starling.supportHighResolutions = true;		
		
			var ratio : Number = viewPort.width / viewPort.height;

			_starling.stage.stageWidth = int(768 * ratio);
			_starling.stage.stageHeight = 768;			
			//_starling.showStats = true;
			_starling.start();
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_starling.stage.addEventListener(starling.events.Event.RESIZE, onStageResizeHandler)

			
			GlobalJuggler.instance.init();
			GlobalDispatcher.instance.init();
			Starling.juggler.add(GlobalJuggler.instance.menuJuggler);
			PlayerModel.instance.loadData();
			
			// CHANGE TO NATIVE APPLICATION!
			//_flashStage.stage.addEventListener(flash.events.Event.DEACTIVATE, onStageDeactivate, false, 0, true); 
			//_flashStage.stage.addEventListener(flash.events.Event.ACTIVATE, onStageActivate, false, 0, true);

		}
		
		private function onRootCreated(e:Event):void 
		{
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			
			_globalView = _starling.root as GlobalView;			
			_globalView.init();
			
			_sceneManager = new SceneManager();
			_sceneManager.init(_globalView);
			
			NativeApplication.nativeApplication.addEventListener("activate", onStageActive); 
			NativeApplication.nativeApplication.addEventListener("deactivate", onStageDeactivate);

			
			initAssets();
		}
		
		private function onStageDeactivate(e:Object):void 
		{
			_starling.stop(true);
		}
		
		private function onStageActive(e:Object):void 
		{
			_starling.start();
		}
		
		private function initAssets():void 
		{
			GlobalAssetManager.instance.init();
			GlobalAssetManager.instance.addEventListener(GlobalAssetManager.ASSETS_LOAD_COMPLETE, onAssetsCompleteHandler);
		}
		
		private function onAssetsCompleteHandler(e:Event):void 
		{
			GlobalAssetManager.instance.removeEventListener(GlobalAssetManager.ASSETS_LOAD_COMPLETE, onAssetsCompleteHandler);
			_globalView.addBackground();
			GlobalDispatcher.instance.dispatchEventWith(Main.REMOVE_START_PRELOADER);
		
			initSounds();
			initBackButtonManager();
			showMenu();
		}
		
		private function initBackButtonManager():void 
		{
			_backButtonManager = new BackButtonManager(_flashStage);
		}
		
		private function initSounds():void 
		{
			SoundAS.group("sounds");
			SoundAS.group("sounds").mute = PlayerModel.instance.mute;
			
			SoundAS.group("sounds").addSound("buttonClicked", GlobalAssetManager.instance.assetManager.getSound("buttonClicked"));
			SoundAS.group("sounds").addSound("cardInSlot", GlobalAssetManager.instance.assetManager.getSound("cardInSlot"));
			SoundAS.group("sounds").addSound("cardPicked", GlobalAssetManager.instance.assetManager.getSound("cardPicked"));
			SoundAS.group("sounds").addSound("cardReturned", GlobalAssetManager.instance.assetManager.getSound("cardReturned"));
			SoundAS.group("sounds").addSound("deckShuffled", GlobalAssetManager.instance.assetManager.getSound("deckShuffled"));
			SoundAS.group("sounds").addSound("popupIn", GlobalAssetManager.instance.assetManager.getSound("popupIn"));
			SoundAS.group("sounds").addSound("popupOut", GlobalAssetManager.instance.assetManager.getSound("popupOut"));
			SoundAS.group("sounds").addSound("mouseClicked", GlobalAssetManager.instance.assetManager.getSound("mouseClicked"));
			SoundAS.group("sounds").addSound("putOnTable", GlobalAssetManager.instance.assetManager.getSound("putOnTable"));
			
			
			
			
		}		
		
		private function showMenu():void 
		{
			new SteelSolitaireTheme();
			
			_sceneManager.preparePreloader();
			GlobalDispatcher.instance.dispatchEventWith(GlobalDispatcher.INIT_MENU);			
		}
		
		private function onStageResizeHandler(e:starling.events.Event):void 
		{
			var viewPort : Rectangle = new Rectangle(0, 0, _flashStage.stageWidth, _flashStage.stageHeight);
			var ratio : Number = viewPort.width / viewPort.height;
			
			_starling.viewPort = viewPort;
			_starling.stage.stageWidth = int(768 * ratio);
			_starling.stage.stageHeight = 768;
			
			_flashStage.stage.scaleMode = StageScaleMode.NO_SCALE;
			_flashStage.stage.align = StageAlign.TOP_LEFT;			
		}
		
	}

}