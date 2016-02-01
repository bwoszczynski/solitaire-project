package manager 
{
	import base.BackButtonAction;
	import feathers.core.PopUpManager;
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import minigame.MinigameView;
	import view.ExitAppPopup;
	import view.MinigameMenuPopup;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class BackButtonManager 
	{
		static public const PREPARE_BACK_ACTION:String = "prepareBackAction";
		static public const MAIN_MENU_BACK_ACTION:String = "mainMenuBackAction";
		static public const MINIGAME_BACK_ACTION:String = "minigameBackAction";
		static public const MINIGAME_MENU_POPUP_ACTION:String = "minigameMenuPopupAction";
		static public const MINIGAME_WON_POPUP_ACTION:String = "minigameWonPopupAction";
		static public const MINIGAME_LOST_POPUP_ACTION:String = "minigameLostPopupAction";
		static public const MAIN_MENU_SETTINGS_POPUP_ACTION:String = "mainMenuSettingsPopupAction";
		static public const MAIN_MENU_STATISTICS_POPUP_ACTION:String = "mainMenuStatisticsPopupAction";
		static public const MAIN_MENU_EXIT_APP_POPUP_ACTION:String = "mainMenuExitAppPopupAction";
		static public const REMOVE_BACK_ACTION:String = "removeBackAction";
		private var _currentBackActionType:BackButtonAction;
		
		public function BackButtonManager(stage:Stage) 
		{
			GlobalDispatcher.instance.addEventListener(PREPARE_BACK_ACTION, onPrepareBackAction);
			GlobalDispatcher.instance.addEventListener(REMOVE_BACK_ACTION, onRemoveBackAction);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onRemoveBackAction(e:Object):void 
		{
			_currentBackActionType = null;
		}
		
		private function onPrepareBackAction(e:Object):void 
		{
			_currentBackActionType = e["data"];			
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			switch (e.keyCode)
			{
				//case Keyboard.BACKSPACE:
				case Keyboard.BACK:
				{
					e.preventDefault();
					triggerBackAction();
					break;
				}
			}
		}
		
		private function triggerBackAction():void 
		{
			if (!_currentBackActionType)
				return;
				
			switch (_currentBackActionType.type)
			{
				case MAIN_MENU_BACK_ACTION:
				{
					PopUpManager.addPopUp(new ExitAppPopup());
					//_currentBackActionType = null;
					break;
				}
				case MAIN_MENU_SETTINGS_POPUP_ACTION:
				case MAIN_MENU_STATISTICS_POPUP_ACTION:
				case MAIN_MENU_EXIT_APP_POPUP_ACTION:
				{
					if(_currentBackActionType.popup)
						_currentBackActionType.popup.hide();
					//_currentBackActionType = null;
					break;
				}
				case MINIGAME_BACK_ACTION:
				{
					GlobalDispatcher.instance.dispatchEventWith(MinigameView.SHOW_MINIGAME_MENU_POPUP);
					break;
				}
				case MINIGAME_WON_POPUP_ACTION:				
				case MINIGAME_LOST_POPUP_ACTION:				
				{
					if(_currentBackActionType.popup)
						_currentBackActionType.popup.forceHide();
						
					//_currentBackActionType = null;
					break;
				}
				case MINIGAME_MENU_POPUP_ACTION:
				{
					if(_currentBackActionType.popup)
						_currentBackActionType.popup.forceHide();
					//_currentBackActionType = null;
					break;
				}				
			}
		}
		
	}

}