package minigame.ui 
{
	import feathers.themes.SteelSolitaireTheme;
	import flash.utils.getTimer;
	import manager.GlobalAssetManager;
	import manager.GlobalJuggler;
	import starling.animation.IAnimatable;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class MinigameTimer extends Sprite implements IAnimatable 
	{
		private var _startTime:Number;
		private var _timerText:TextField;
		private var _movesText:TextField;
		
		public function MinigameTimer() 
		{
			super();
			
			var img:Image = new Image(GlobalAssetManager.instance.assetManager.getTexture("timerBg"));
				addChild(img);
				
			_timerText = new TextField(img.width - 40, img.height, "", SteelSolitaireTheme.MAIN_FONT, 42, 0xFFFFFF, true);
			_timerText.x = 40;
			_timerText.vAlign = VAlign.CENTER;
			_timerText.hAlign = HAlign.LEFT;
			addChild(_timerText);
			
			_movesText = new TextField(img.width, img.height, "Moves", SteelSolitaireTheme.MAIN_FONT, 42, 0xFFFFFF, true);
			_movesText.x = 15;
			_movesText.vAlign = VAlign.CENTER;
			_movesText.hAlign = HAlign.LEFT;
			addChild(_movesText);
			
			_startTime = GlobalJuggler.instance.minigameJuggler.elapsedTime;
		}
		
		public function showTimer():void
		{
			_movesText.visible = false;
			_timerText.visible = true;
		}
		
		public function showMoves():void
		{
			_movesText.visible = true;
			_timerText.visible = false;			
		}
		
		public function updateMoves(value:int):void
		{
			_movesText.text = "Moves   " + value.toString();
		}
		
		public function displayTime(time:Number):void
		{
			_timerText.text = parseTimeToShow(time);
		}
		
		public function advanceTime(time:Number):void 
		{
			var timePassed:Number = GlobalJuggler.instance.minigameJuggler.elapsedTime - _startTime;
			
			_timerText.text = parseTimeToShow(timePassed);
			
		}
		
		public static function parseTimeToShow(timePassed:Number):String 
		{
			var result:String;
			
			var seconds:int = (timePassed) % 60;
			var minutes:int = (timePassed / 60) % 60;
			var hours:int = (timePassed / (60 * 60)) % 24;
		 
			result = roundTime(hours) + ":" + roundTime(minutes) + ":" + roundTime(seconds);
			
			return result;
		}	
		
		public function get currentGameTime():Number
		{
			return GlobalJuggler.instance.minigameJuggler.elapsedTime - _startTime;
		}
		
		private static function roundTime(value:Number):String
		{
			return (value < 10) ? "0" + value.toFixed() : value.toFixed();
		}
		
		override public function dispose():void 
		{
			this.removeChildren(0, -1, true);
			
			super.dispose();
		}
		
	}

}