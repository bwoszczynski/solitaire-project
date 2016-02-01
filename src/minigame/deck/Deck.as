package minigame.deck 
{
	import feathers.controls.Button;
	import interfaces.ISelectable;
	import manager.GlobalAssetManager;
	import manager.GlobalJuggler;
	import starling.animation.Tween;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class Deck extends Button implements ISelectable 
	{
		private var _glow:Image;
		
		public function Deck() 
		{
			super();
			
			_glow = new Image(GlobalAssetManager.instance.assetManager.getTexture("cardGlow"));
			
			_glow.alignPivot();
			_glow.x = -11;
			_glow.y = -7;			
			_glow.visible = false;
			_glow.touchable = false;
			
			_glow.x += _glow.pivotX;
			_glow.y += _glow.pivotY;
			
			this.soundName = null;
			addChild(_glow);
		}
		
		/* INTERFACE interfaces.ISelectable */
		
		public function select(withAnim:Boolean = false):void 
		{
			setStartGlowValues();
			this.setChildIndex(_glow, numChildren - 1);
			_glow.visible = true;
			
			
			if (withAnim)
			{
				_glow.alpha = 0;
				var tween:Tween = new Tween(_glow, 0.6);
					tween.scaleTo(1.1);
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
			_glow.scaleX = _glow.scaleY = 1;
			_glow.alpha = 1;
		}
		
		override public function dispose():void 
		{
			GlobalJuggler.instance.minigameJuggler.removeTweens(_glow);
			
			super.dispose();
		}
	}

}