package view 
{
	import base.BackButtonAction;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.SteelSolitaireTheme;
	import manager.BackButtonManager;
	import manager.GlobalDispatcher;
	import minigame.ui.MinigameTimer;
	import player.PlayerModel;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class StatisticsPopup extends BasePopupView 
	{
		
		public function StatisticsPopup() 
		{
			super();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MAIN_MENU_STATISTICS_POPUP_ACTION, this));
			
			_headerText.text = "STATISTICS";
			
			var statsContainer:LayoutGroup = new LayoutGroup();
			var layout:VerticalLayout = new VerticalLayout();
				layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
				layout.gap = -1;
				layout.paddingTop = 70;
				layout.paddingLeft = layout.paddingRight = 10;
				//layout.lastGap = 20;
				statsContainer.layout = layout;
				
			statsContainer.width = _bg.width = 600;
			statsContainer.height = _bg.height = 694;
			_graphicsContainer.addChild(statsContainer);
			
			var text:TextField = new TextField(_bg.width - 20, 40, "GENERAL", SteelSolitaireTheme.MAIN_FONT, 36, 0x835D25, true);
			statsContainer.addChild(text);
			
			var sprite:Sprite = new Sprite();
			text = generateText("GAMES PLAYED:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(PlayerModel.instance.allGamesNum.toString(), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);
			
			sprite = new Sprite();
			text = generateText("GAMES WON:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(PlayerModel.instance.allWonGamesNum.toString(), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);			
			
			sprite = new Sprite();
			text = generateText("GAMES LOST:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(PlayerModel.instance.allLostGamesNum.toString(), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);			
			
			sprite = new Sprite();
			text = generateText("RATIO:", HAlign.LEFT);
			sprite.addChild(text);
			var textRatio:String = PlayerModel.instance.allRatio == 0 ? "0" : PlayerModel.instance.allRatio.toFixed(2);
			text = generateText(textRatio + "%", HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);
			
			////////////////////////////////////////////////////////////////////////////////
			text = new TextField(_bg.width - 20, 40, "TIME MODE", SteelSolitaireTheme.MAIN_FONT, 36, 0x835D25, true);
			statsContainer.addChild(text);
			
			sprite = new Sprite();
			text = generateText("GAMES PLAYED:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(String(PlayerModel.instance.gamesNum(PlayerModel.TIME_GAME, PlayerModel.WON) + PlayerModel.instance.gamesNum(PlayerModel.TIME_GAME, PlayerModel.LOST)), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);
			
			sprite = new Sprite();
			text = generateText("GAMES WON:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(PlayerModel.instance.gamesNum(PlayerModel.TIME_GAME, PlayerModel.WON).toString(), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);			
			
			sprite = new Sprite();
			text = generateText("GAMES LOST:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(PlayerModel.instance.gamesNum(PlayerModel.TIME_GAME, PlayerModel.LOST).toString(), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);			
			
			sprite = new Sprite();
			text = generateText("RATIO:", HAlign.LEFT);
			sprite.addChild(text);
			textRatio = PlayerModel.instance.getRatioByType(PlayerModel.TIME_GAME) == 0 ? "0" : PlayerModel.instance.getRatioByType(PlayerModel.TIME_GAME).toFixed(2);
			text = generateText(textRatio + "%", HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);
			
			sprite = new Sprite();
			text = generateText("BEST TIME:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(MinigameTimer.parseTimeToShow(PlayerModel.instance.bestTime), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);
			
			/////////////////////////////////////////////////////////////////////
			text = new TextField(_bg.width - 20, 40, "MOVES MODE", SteelSolitaireTheme.MAIN_FONT, 36, 0x835D25, true);
			statsContainer.addChild(text);
			
			sprite = new Sprite();
			text = generateText("GAMES PLAYED:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(String(PlayerModel.instance.gamesNum(PlayerModel.MOVES_GAME, PlayerModel.WON) + PlayerModel.instance.gamesNum(PlayerModel.MOVES_GAME, PlayerModel.LOST)), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);
			
			sprite = new Sprite();
			text = generateText("GAMES WON:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(PlayerModel.instance.gamesNum(PlayerModel.MOVES_GAME, PlayerModel.WON).toString(), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);			
			
			sprite = new Sprite();
			text = generateText("GAMES LOST:", HAlign.LEFT);
			sprite.addChild(text);
			text = generateText(PlayerModel.instance.gamesNum(PlayerModel.MOVES_GAME, PlayerModel.LOST).toString(), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);			
			
			sprite = new Sprite();
			text = generateText("RATIO:", HAlign.LEFT);
			sprite.addChild(text);
			textRatio = PlayerModel.instance.getRatioByType(PlayerModel.MOVES_GAME) == 0 ? "0" : PlayerModel.instance.getRatioByType(PlayerModel.MOVES_GAME).toFixed(2);
			text = generateText(textRatio + "%", HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);
			
			sprite = new Sprite();
			text = generateText("MIN MOVES:", HAlign.LEFT, 0xA08770, 34);
			sprite.addChild(text);
			text = generateText(PlayerModel.instance.smallestMovesNum.toString(), HAlign.RIGHT);
			sprite.addChild(text);
			statsContainer.addChild(sprite);
			
			_header.x = int(_bg.width / 2 - _header.width / 2);
			
			prepareOkButton();
			
		}
		
		override protected function shown():void 
		{
			//super.shown();
			dispatchEventWith(POPUP_SHOWN);
		}
		
		override public function clean():void 
		{
			//super.clean();
			dispatchEventWith(POPUP_HIDDEN, false,  _exitData);			
			this.removeChildren(0, -1, true);
			this.removeFromParent(true);
			Starling.juggler.removeTweens(_graphicsContainer);
		}
		
		override public function prepareOkButton():void 
		{
			//super.prepareOkButton();
			var cont:LayoutGroup = new LayoutGroup();
			var layout:HorizontalLayout = new HorizontalLayout();
				layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
				layout.gap = 15;
				cont.layout = layout;
				cont.width = _bg.width;			
				
			var button:Button = new Button();
				button.styleName = SteelSolitaireTheme.POPUP_SIMPLE_BUTTON;
				button.label = "BACK";				
				button.addEventListener(Event.TRIGGERED, function():void { hide() } );
				cont.addChild(button);
				_graphicsContainer.addChild(cont);
				
				button = new Button();
				button.styleName = SteelSolitaireTheme.POPUP_SIMPLE_BUTTON;
				button.label = "RESET";				
				button.addEventListener(Event.TRIGGERED, resetStats);
				cont.addChild(button);
				_graphicsContainer.addChild(cont);
				
				cont.y = _bg.height - button.height + 5;
		}
		
		private function resetStats(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.TRIGGERED, resetStats);
			
			PlayerModel.instance.clearStatisticsData(); 
			PlayerModel.instance.loadData(); 
			hide();
		}
		
		private function generateText(text:String, align:String, color:Number = 0xA08770, fontSize:Number = 34):TextField
		{
			var textWidth:Number = align == HAlign.LEFT ? _bg.width - 80 : _bg.width - 90;
			
			var textField:TextField = new TextField(textWidth, fontSize + 4, text, SteelSolitaireTheme.MAIN_FONT, fontSize, color, true);
			textField.hAlign = align;
			
			return textField;
		}
		
		override public function hide():void 
		{
			super.hide();
			
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MAIN_MENU_BACK_ACTION));
			
		}
		
	}

}