package manager 
{
	import interfaces.IController;
	import menu.MenuController;
	import minigame.MinigameController;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import view.GlobalView;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class SceneManager 
	{
		private var _globalView:GlobalView;
		private var _activeController:IController;
		private var _preloaderContainer:Sprite;
		
		public function SceneManager() 
		{
			GlobalDispatcher.instance.addEventListener(GlobalDispatcher.INIT_MINIGAME, onInitSceneHandler);
			GlobalDispatcher.instance.addEventListener(GlobalDispatcher.INIT_MENU, onInitSceneHandler);
		}
		
		private function onInitSceneHandler(e:Event):void 
		{
			var prevController:IController;
			
			if (_activeController)
				prevController = _activeController;
			
			if (e.type == GlobalDispatcher.INIT_MENU)
				_activeController = new MenuController();
			else if (e.type == GlobalDispatcher.INIT_MINIGAME)
				_activeController = new MinigameController();
				
			_activeController.init();
			showPreloader();
			
			GlobalJuggler.instance.menuJuggler.delayCall(hidePreloader, 1.5);
			_globalView.minigameLayer.addChild(_activeController.sceneView);
			
			if (prevController)
			{
				prevController.clean();
				prevController = null;
			}
		}
		
		public function init(globalView:GlobalView):void 
		{
			_globalView = globalView;
			
		}
		
		public function preparePreloader():void 
		{
			_preloaderContainer = new Sprite();
			
			var quad:Quad = new Quad(GlobalView.WIDTH, GlobalView.HEIGHT, 0x000000);
				quad.alpha = 0.8;
				_preloaderContainer.addChild(quad);
			var img:Image = new Image(GlobalAssetManager.instance.assetManager.getTexture("mainMenuPicture"));
				img.x = int(GlobalView.WIDTH / 2 - img.width / 2);
				img.y = int(GlobalView.HEIGHT / 2 - img.height / 2);
				_preloaderContainer.addChild(img);
				
			_globalView.preloaderLayer.addChild(_preloaderContainer);
			_preloaderContainer.visible = false;
		}
		public function showPreloader():void
		{
			_activeController.sceneView.alpha = 0;
			_preloaderContainer.visible = true;
		}
		
		public function hidePreloader():void
		{
			_activeController.sceneView.alpha = 1;
			_preloaderContainer.visible = false;
		}
		
	}

}