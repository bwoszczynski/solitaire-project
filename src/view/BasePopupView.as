package view 
{
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import feathers.themes.SteelSolitaireTheme;
	import flash.geom.Rectangle;
	import manager.GlobalAssetManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.VAlign;
	import treefortress.sound.SoundAS;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class BasePopupView extends Sprite
	{		
		static public const POPUP_HIDDEN:String = "popupHidden";
		static public const POPUP_SHOWN:String = "popupShown";
		static public const CANCEL:String = "cancel";
		private var _tween:Tween;
		protected var _graphicsContainer:Sprite;
		protected var _headerText:TextField;
		protected var _bg:Scale9Image;
		protected var _header:Sprite;
		protected var _exitData:Object;
		
		public function BasePopupView(data:Object = null) 
		{
			_graphicsContainer = new Sprite();
			
			var textures:Scale9Textures = new Scale9Textures(GlobalAssetManager.instance.assetManager.getTexture("popupBg"), new Rectangle(29, 28, 2, 2));
			_bg = new Scale9Image(textures);
			_bg.y = 35;
			_graphicsContainer.addChild(_bg);
			
			_header = new Sprite();
			var img:Image;
				img = new Image(GlobalAssetManager.instance.assetManager.getTexture("popupHeader"));
			_header.addChild(img);
			
			_headerText = new TextField(img.width, img.height - 20, "", SteelSolitaireTheme.MAIN_FONT, 46, 0xE3FFC6, true);
				_headerText.vAlign = VAlign.CENTER;
				_headerText.autoScale = true;
			_header.addChild(_headerText);
			
			_graphicsContainer.addChild(_header);
			
			addChild(_graphicsContainer);
			_graphicsContainer.y = -Starling.current.stage.stageHeight;
		}
		
		public function forceHide():void
		{
			
		}
		
		public function prepareOkButton():void
		{
			var button:Button = new Button();
				button.styleName = SteelSolitaireTheme.POPUP_SIMPLE_BUTTON;
				button.label = "BACK";
				button.x = int(_bg.width / 2 - 81);
				button.y = _bg.height - button.height + 5;
				button.addEventListener(Event.TRIGGERED, function():void { hide()} );
				_graphicsContainer.addChild(button);
		}
		
		public function show():void
		{			
			SoundAS.group("sounds").play("popupIn");
			_tween = new Tween(_graphicsContainer, 0.3, Transitions.EASE_OUT_BACK);
			_tween.moveTo(_graphicsContainer.x, 0);
			_tween.onComplete = shown;
			
			Starling.juggler.add(_tween);	
		}
		
		protected function shown():void 
		{
			dispatchEventWith(POPUP_SHOWN);			
		}
		
		public function hide():void
		{
			SoundAS.group("sounds").play("popupOut");
			
			if (_tween)
				Starling.juggler.remove(_tween);
				
			_tween = new Tween(_graphicsContainer, 0.3, Transitions.EASE_IN_BACK);
			_tween.moveTo(_graphicsContainer.x, -Starling.current.stage.stageHeight);
			_tween.onComplete = clean;
				
			Starling.juggler.add(_tween);		
		}
		
		public function clean():void
		{				
			dispatchEventWith(POPUP_HIDDEN, false,  _exitData);			
			this.removeChildren(0, -1, true);
			this.removeFromParent(true);
			Starling.juggler.removeTweens(_graphicsContainer);
		}
	}

}