package view 
{
	import base.BackButtonAction;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.layout.VerticalLayout;
	import feathers.themes.SteelSolitaireTheme;
	import manager.BackButtonManager;
	import manager.GlobalDispatcher;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class MinigameMenuPopup extends BasePopupView 
	{
		static public const MAIN_MENU:String = "mainMenu";
		static public const REPLAY:String = "replay";
		static public const NEW_GAME:String = "newGame";
		
		public function MinigameMenuPopup(data:Object = null) 
		{
			super();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_MENU_POPUP_ACTION, this));
			
			_headerText.text = "GAME MENU";
			
			var buttonsContainer:LayoutGroup = new LayoutGroup();
			var layout:VerticalLayout = new VerticalLayout();
				layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
				layout.gap = 20;
				layout.paddingTop = 70;
				layout.lastGap = 50;
				buttonsContainer.layout = layout;
			var button:Button = new Button();
			
			button = new Button();
			button.label = "REPLAY GAME";
			button.styleName = SteelSolitaireTheme.MINIGAME_SIMPLE_BUTTON;
			button.addEventListener(Event.TRIGGERED, onReplayGameHandler);
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
		
		override public function forceHide():void 
		{
			onHideHandler(null);
		}
		
		private function onHideHandler(e:Event):void 
		{
			if (e)
				e.currentTarget.removeEventListeners();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_BACK_ACTION));
			_exitData = {type: BasePopupView.CANCEL };
			hide();
		}
		
		private function onMainMenuHandler(e:Event):void 
		{
			e.currentTarget.removeEventListeners();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.REMOVE_BACK_ACTION);
			_exitData = {type: MinigameMenuPopup.MAIN_MENU };
			hide();
		}
		private function onReplayGameHandler(e:Event):void 
		{
			e.currentTarget.removeEventListeners();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_BACK_ACTION));
			_exitData = {type: MinigameMenuPopup.REPLAY };
			hide();
		}
		private function onNewGameHandler(e:Event):void 
		{
			e.currentTarget.removeEventListeners();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_BACK_ACTION));
			_exitData = {type: MinigameMenuPopup.NEW_GAME };
			hide();
		}		
	}

}