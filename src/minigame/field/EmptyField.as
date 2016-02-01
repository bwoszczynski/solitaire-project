package minigame.field 
{
	import feathers.controls.Button;
	import interfaces.ISelectable;
	import manager.GlobalAssetManager;
	import manager.GlobalDispatcher;
	import manager.GlobalJuggler;
	import minigame.card.CardView;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class EmptyField extends Sprite implements ISelectable
	{
		private var _selectButton:Button;
		private var _glow:Image;
		public var num:int;
		public var isAvailable:Boolean;
		
		static public const EMPTY_FIELD_SELECTED:String = "emptyFieldSelected";
		
		public function EmptyField() 
		{			
			var img:Image = new Image(GlobalAssetManager.instance.assetManager.getTexture("emptySlot"));
			
			_glow = new Image(GlobalAssetManager.instance.assetManager.getTexture("cardGlow"));
			_glow.alignPivot();
			_glow.x = -15;
			_glow.y = -7;			
			_glow.visible = false;
			
			_glow.x += _glow.pivotX;
			_glow.y += _glow.pivotY;
			_glow.touchable = false;
			
			_selectButton = new Button();
			_selectButton.defaultSkin = img;
			_selectButton.soundName = "putOnTable";
			_selectButton.addEventListener(Event.TRIGGERED, onSlotSelectedHandler);
			addChild(_selectButton);
			_selectButton.x = -4;
			
			addChild(_glow);
			setStartGlowValues();
			//img.y = -7;
			
			this.alpha = 0;
			
			isAvailable = false;
		}
			
		public function select(withAnim:Boolean = false):void
		{
			this.setChildIndex(_glow, numChildren - 1);
			_glow.visible = true;
			
			
			if (withAnim)
			{
				_glow.alpha = 0;
				var tween:Tween = new Tween(_glow, 0.6);
					tween.scaleTo(1.2);
					tween.fadeTo(1);
					tween.reverse = true;
					tween.repeatCount = 0;
					GlobalJuggler.instance.minigameJuggler.add(tween);
			}
		}
		
		public function unselect():void
		{
			setStartGlowValues();
		}
		
		public function setStartGlowValues():void 
		{
			GlobalJuggler.instance.minigameJuggler.removeTweens(_glow);
			_glow.visible = false;
			_glow.scaleX = _glow.scaleY = 1.1;
			_glow.alpha = 1;
		}
		
		private function onSlotSelectedHandler(e:Event):void 
		{
			GlobalDispatcher.instance.dispatchEventWith(EMPTY_FIELD_SELECTED, false, this);	
		}
		
		override public function dispose():void 
		{
			GlobalJuggler.instance.minigameJuggler.removeTweens(_glow);
			_selectButton.removeEventListeners();
			_selectButton.removeFromParent(true);
			_selectButton = null;
			
			super.dispose();
		}
	}

}