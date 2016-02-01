package view 
{
	import feathers.controls.LayoutGroup;
	import feathers.display.Scale9Image;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import manager.GlobalAssetManager;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class GlobalView extends Sprite
	{
		private var _menuLayer:Sprite;
		private var _minigameLayer:Sprite;
		private var _preloaderLayer:Sprite;
		private var _popupsLayer:Sprite;
		private var _bgLayer:LayoutGroup;
		
		static public var WIDTH:int;
		static public var HEIGHT:int;
		
		public function GlobalView() 
		{
			
		}
		
		public function init():void 
		{
			_bgLayer = new LayoutGroup();
			var bgLayout:AnchorLayout = new AnchorLayout();				
			addChild(_bgLayer);
			
			_menuLayer = new Sprite();
			addChild(_menuLayer);
			
			_minigameLayer = new Sprite();
			addChild(_minigameLayer);			
			
			_preloaderLayer = new Sprite();
			addChild(_preloaderLayer);
			
			_popupsLayer = new Sprite();
			addChild(_popupsLayer);
			
			WIDTH = Starling.current.stage.stageWidth;
			HEIGHT = Starling.current.stage.stageHeight;
			
			_bgLayer.layout = bgLayout;
			_bgLayer.width = GlobalView.WIDTH;
			_bgLayer.height = GlobalView.HEIGHT;
			
		}
		
		public function addBackground():void
		{
			var img:Image;
			var frame:Scale9Image;
			if (GlobalView.HEIGHT / GlobalView.WIDTH < 0.72)
			{
				img = new Image(GlobalAssetManager.instance.assetManagerSD.getTexture("bg_16_9"));
				frame = new Scale9Image(new Scale9Textures(GlobalAssetManager.instance.assetManager.getTexture("frame"), new Rectangle(15, 15, 5, 5)));
				frame.x = 10;
				frame.y = 10;
				frame.width = GlobalView.WIDTH - 20;
				frame.height = GlobalView.HEIGHT - 20;
			}
			else
				img = new Image(GlobalAssetManager.instance.assetManagerSD.getTexture("bg"));
				
			var cont:LayoutGroup = new LayoutGroup();
				cont.width = GlobalView.WIDTH;
				cont.height = GlobalView.HEIGHT;
				cont.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, NaN);
				cont.addChild(img);
				if (frame)
					cont.addChild(frame);
			_bgLayer.addChild(cont);
		}
		
		public function get menuLayer():Sprite 
		{
			return _menuLayer;
		}
		
		public function get minigameLayer():Sprite 
		{
			return _minigameLayer;
		}
		
		public function get preloaderLayer():Sprite 
		{
			return _preloaderLayer;
		}
		
		public function get popupsLayer():Sprite 
		{
			return _popupsLayer;
		}
		
	}

}