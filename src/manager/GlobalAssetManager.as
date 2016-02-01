package manager 
{
	import starling.events.EventDispatcher;
	import starling.utils.AssetManager;
	import view.GlobalView;
	/**
	 * ...
	 * @author JA
	 */
	public class GlobalAssetManager extends EventDispatcher
	{
		static public const ASSETS_LOAD_COMPLETE:String = "assetsLoadComplete";
		static private var _instance:GlobalAssetManager;
		
		private var _assetManagerSD:AssetManager;
		private var _assetManager:AssetManager;
		private var _loaderCounter:int = 0;
		
		public function GlobalAssetManager() 
		{
			_assetManager = new AssetManager(2);
			_assetManagerSD = new AssetManager();
		}

		public function init():void
		{
			_assetManager.enqueue("./assets/HD/HD.png");
			_assetManager.enqueue("./assets/HD/HD.xml");
			_assetManager.enqueue("./assets/sounds/popupIn.mp3");
			_assetManager.enqueue("./assets/sounds/popupOut.mp3");
			_assetManager.enqueue("./assets/sounds/buttonClicked.mp3");
			_assetManager.enqueue("./assets/sounds/cardInSlot.mp3");
			_assetManager.enqueue("./assets/sounds/cardPicked.mp3");
			_assetManager.enqueue("./assets/sounds/cardReturned.mp3");
			_assetManager.enqueue("./assets/sounds/deckShuffled.mp3");
			_assetManager.enqueue("./assets/sounds/mouseClicked.mp3");
			_assetManager.enqueue("./assets/sounds/putOnTable.mp3");
			
			_assetManagerSD.enqueue("./assets/SD/Bespoke.fnt");
			_assetManagerSD.enqueue("./assets/SD/Bespoke_0.png");
			
			var bgAssetId:String;
			
			if (GlobalView.HEIGHT / GlobalView.WIDTH < 0.72)
				bgAssetId = "bg_16_9";
			else
				bgAssetId = "bg";
				
			_assetManagerSD.enqueue("./assets/SD/" + bgAssetId + ".png");
			
			_assetManager.loadQueue(onProgress);
			_assetManagerSD.loadQueue(onProgress);
		}
		
		private function onProgress(ratio:Number):void 
		{
			if (ratio == 1)
			{
				_loaderCounter++;
				if (_loaderCounter == 2)
					dispatchEventWith(ASSETS_LOAD_COMPLETE);
			}
		}
		
		static public function get instance():GlobalAssetManager 
		{
			if (!_instance)
				_instance = new GlobalAssetManager();
				
			return _instance;
		}
		
		public function get assetManager():AssetManager 
		{
			return _assetManager;
		}
		
		public function get assetManagerSD():AssetManager 
		{
			return _assetManagerSD;
		}
		
	}
}