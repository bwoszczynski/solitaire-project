package view 
{
	import base.BackButtonAction;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.layout.VerticalLayout;
	import feathers.themes.SteelSolitaireTheme;
	import manager.BackButtonManager;
	import manager.GlobalDispatcher;
	import minigame.ui.MinigameTimer;
	import player.PlayerModel;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class EndGamePopup extends BasePopupView 
	{		
		static public const MAIN_MENU:String = "mainMenu";
		static public const REPLAY:String = "replay";
		static public const NEW_GAME:String = "newGame";
		
		private var _won:Boolean;
		private var _timer:MinigameTimer;
		
		public function EndGamePopup(data:Object = null) 
		{
			super();
			
			_won = data["won"];
			
			var infoText:TextField = new TextField( 460, 110, "", SteelSolitaireTheme.MAIN_FONT, 56, 0xA08770, true);
				infoText.autoScale = true;
			if (_won)
			{
				GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_WON_POPUP_ACTION, this));
			
				_headerText.text = "WELL DONE!";
				infoText.text = "Congratulations! \nYou won!";
			}
			else
			{
				GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_LOST_POPUP_ACTION, this));
			
				_headerText.text = "END GAME";
				infoText.text = "Unfortunately you lost.\n Try again!";
			}
			
				
			var buttonsContainer:LayoutGroup = new LayoutGroup();
			var layout:VerticalLayout = new VerticalLayout();
				layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
				layout.firstGap = 25;
				layout.gap = 15;
				layout.paddingTop = 90;
				layout.paddingLeft = layout.paddingRight = 20;
				buttonsContainer.layout = layout;
			var button:Button = new Button();
			
			buttonsContainer.addChild(infoText);
			
			if (_won)
			{
				_timer = new MinigameTimer();
				PlayerModel.instance.gameType == PlayerModel.MOVES_GAME ? _timer.showMoves() : _timer.showTimer();
				
				_timer.updateMoves(data["moves"]);
				_timer.displayTime(data["time"]);
				
				buttonsContainer.addChild(_timer);
			}
			
			button = new Button();
			button.label = "REPLAY GAME";
			button.styleName = SteelSolitaireTheme.MINIGAME_SIMPLE_BUTTON;
			button.addEventListener(Event.TRIGGERED, onReplayGameHandler);
			if (!_won)
				buttonsContainer.addChild(button);
			
			button = new Button();
			button.label = "NEW GAME";
			button.styleName = SteelSolitaireTheme.MINIGAME_SIMPLE_BUTTON;
			button.addEventListener(Event.TRIGGERED, onNewGameHandler);
			buttonsContainer.addChild(button);
			
			button = new Button();
			button.label = "MAIN MENU";
			button.styleName = SteelSolitaireTheme.MINIGAME_SIMPLE_BUTTON;
			button.addEventListener(Event.TRIGGERED, onMainMenuHandler);
			buttonsContainer.addChild(button);
			
			button = new Button();
			button.label = "CANCEL";
			button.styleName = SteelSolitaireTheme.MINIGAME_SIMPLE_BUTTON;
			button.addEventListener(Event.TRIGGERED, onHideHandler);
			if (!_won)
				buttonsContainer.addChild(button);
			
			_graphicsContainer.addChild(buttonsContainer);
			
			_bg.width = buttonsContainer.width = 500;
			_bg.height = buttonsContainer.height = 500;
			_header.x = int(_bg.width / 2 - _header.width / 2);
			buttonsContainer.invalidate();
			buttonsContainer.validate();
			//buttonsContainer.x = int(GlobalView.WIDTH / 2 - buttonsContainer.width / 2);
			//buttonsContainer.y = int(_bg.height - buttonsContainer.height / 2);
		}
		
		
		override public function clean():void 
		{
			super.clean();
			if (_timer)
				_timer.removeFromParent(true);
		}
		
		override public function forceHide():void 
		{
			if (!_won)
				onHideHandler(null);
			else
				onMainMenuHandler(null);
		}
		
		private function onHideHandler(e:Event):void 
		{
			if (e)
				e.currentTarget.removeEventListeners();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_BACK_ACTION));
			
			_exitData = {type: BasePopupView.CANCEL, won: _won};
			hide();
		}
		
		private function onMainMenuHandler(e:Event):void 
		{
			if (e)
				e.currentTarget.removeEventListeners();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.REMOVE_BACK_ACTION);
			_exitData = {type: MinigameMenuPopup.MAIN_MENU, won: _won};
			hide();
		}
		private function onReplayGameHandler(e:Event):void 
		{
			e.currentTarget.removeEventListeners();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_BACK_ACTION));
					
			_exitData = {type: MinigameMenuPopup.REPLAY, won: _won};
			hide();
		}
		private function onNewGameHandler(e:Event):void 
		{
			e.currentTarget.removeEventListeners();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_BACK_ACTION));
					
			_exitData = {type: MinigameMenuPopup.NEW_GAME, won: _won};
			hide();
		}
	}

}